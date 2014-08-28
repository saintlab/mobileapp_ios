//
//  OMNOrder.m
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"
#import "OMNOperationManager.h"
#import "OMNSocketManager.h"

@implementation OMNOrder {
  id _data;
  NSString *_callBillOrderId;
}

- (void)dealloc {
  [[OMNSocketManager manager] leave:self.id];
}

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    _data = jsonData;
    self.id = jsonData[@"id"];
    self.amount = [jsonData[@"amount"] longLongValue];
    self.created = jsonData[@"created"];
    self.Description = jsonData[@"description"];
    self.notes = jsonData[@"notes"];
    self.status = jsonData[@"status"];
    self.openTime = jsonData[@"open_time"];
    self.modifiedTime = jsonData[@"modified_time"];
    self.restaurant_id = jsonData[@"restaurant_id"];
    self.tableId = jsonData[@"table_id"];
    self.paid_amount = [jsonData[@"paid_amount"] longLongValue];
    
    NSArray *itemsData = jsonData[@"items"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:itemsData.count];
    [itemsData enumerateObjectsUsingBlock:^(id itemData, NSUInteger idx, BOOL *stop) {
      
      [items addObject:[[OMNOrderItem alloc] initWithJsonData:itemData]];
      
    }];
    self.items = items;
    
    NSDictionary *tipsData = jsonData[@"tips"];

    _tipsThreshold = [tipsData[@"threshold"] longLongValue];
    NSMutableArray *tips = [NSMutableArray arrayWithCapacity:4];

    for (id tipData in tipsData[@"values"]) {
      long long amount = [tipData[@"amount"] longLongValue];
      double percent = [tipData[@"percent"] doubleValue];
      OMNTip *tip = [[OMNTip alloc] initWithAmount:amount percent:percent];
      [tips addObject:tip];
    }
    OMNTip *tip = tips[3];
    tip.amount = 0;
    _tips = [tips copy];
    
  }
  return self;
}

- (void)deselectAll {
  
  [_items enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(OMNOrderItem *orderItem, NSUInteger idx, BOOL *stop) {
    
    [orderItem deselect];
    
  }];
  
}

- (long long)total {
  
  return [self totalForAllItems:YES];
  
}

- (long long)selectedItemsTotal {
  
  return [self totalForAllItems:NO];
  
}

- (long long)totalForAllItems:(BOOL)allItems {
  
  const long long kKopsInRuble = 100;
  __block long long total = 0.;
  [_items enumerateObjectsUsingBlock:^(OMNOrderItem *orderItem, NSUInteger idx, BOOL *stop) {
    
    if (allItems ||
        orderItem.selected) {
      total += orderItem.price * kKopsInRuble;
    }
    
  }];
  
  return total;
  
}

- (void)createBill:(OMNBillBlock)completion failure:(void (^)(NSError *error))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"amount": @(self.toPayAmount),
    @"restaurant_id" : self.restaurant_id,
    @"restaurateur_order_id" : self.id,
    @"table_id" : self.tableId,
    };
  
  [[OMNOperationManager sharedManager] POST:@"/bill" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"status"]) {
      OMNBill *bill = [[OMNBill alloc] initWithJsonData:responseObject];
      completion(bill);
    }
    else {
      failureBlock(nil);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(nil);
    
  }];
  
}

- (void)billCall:(dispatch_block_t)completionBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders/%@/bill/call", self.restaurant_id, self.tableId, self.id];

  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"status"]) {
      
      [[OMNSocketManager manager] join:self.id];
      
      completionBlock();
    }
    else {
      failureBlock([NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : [responseObject description]}]);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
}

- (void)billCallStop:(dispatch_block_t)completionBlock failure:(void (^)(NSError *error))failureBlock {
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders/%@/bill/call/stop", self.restaurant_id, self.tableId, self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"status"]) {
      [[OMNSocketManager manager] leave:self.id];
      completionBlock();
    }
    else {
      failureBlock([NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : [responseObject description]}]);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
}


@end
