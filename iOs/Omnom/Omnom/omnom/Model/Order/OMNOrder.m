//
//  OMNOrder.m
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"
#import "OMNOperationManager.h"

@implementation OMNOrder

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    self.ID = data[@"id"];
    self.amount = [data[@"amount"] integerValue];
    self.created = data[@"created"];
    self.Description = data[@"description"];
    self.notes = data[@"notes"];
    self.status = data[@"status"];
    self.openTime = data[@"openTime"];
    self.modifiedTime = data[@"modifiedTime"];
    self.restaurant_id = data[@"restaurantId"];
    self.tableId = data[@"tableId"];
    
    NSArray *itemsData = data[@"items"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:itemsData.count];
    [itemsData enumerateObjectsUsingBlock:^(id itemData, NSUInteger idx, BOOL *stop) {
      
      [items addObject:[[OMNOrderItem alloc] initWithData:itemData]];
      
    }];
    self.items = items;
    
    //TODO: remove stub data
    OMNTip *tip1 = [[OMNTip alloc] initWithAmount:30. percent:10];
    OMNTip *tip2 = [[OMNTip alloc] initWithAmount:50. percent:15];
    OMNTip *tip3 = [[OMNTip alloc] initWithAmount:100. percent:20];
    OMNTip *tip4 = [[OMNTip alloc] initWithAmount:0. percent:0];
    _tips = @[tip1, tip2, tip3, tip4];
    _tipsThreshold = 250.;
  }
  return self;
}

- (void)deselectAll {
  
  [_items enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(OMNOrderItem *orderItem, NSUInteger idx, BOOL *stop) {
    
    [orderItem deselect];
    
  }];
  
}

- (double)total {
  
  return [self totalForAllItems:YES];
  
}

- (double)selectedItemsTotal {
  
  return [self totalForAllItems:NO];
  
}

- (double)totalForAllItems:(BOOL)allItems {
  
  __block double total = 0.;
  [_items enumerateObjectsUsingBlock:^(OMNOrderItem *orderItem, NSUInteger idx, BOOL *stop) {
    
    if (allItems ||
        orderItem.selected) {
      total += orderItem.price;
    }
    
  }];
  
  return total;
  
}

- (void)createAcquiringOrder:(OMNOrderPayURLBlock)completion failure:(OMNErrorBlock)failureBlock {
  
  NSDictionary *order =
  @{
    @"description": @"Кебаб",
    @"amount": @(99999),
    @"restaurant_id" : self.restaurant_id,
    @"table_id" : self.tableId,
    };

  NSDictionary *transaction =
  @{
    @"amount" : @(self.toPayAmount),
    @"tip" : @(self.tipAmount),
    };
  
  NSDictionary *parameters =
  @{
    @"order" : order,
    @"transaction" : transaction,
    };
  
  [[OMNOperationManager sharedManager] POST:@"/acquiring/orders" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSString *url = responseObject[@"link"];
    if (url.length) {
      completion(url);
    }
    else {
      failureBlock(nil);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
}

@end
