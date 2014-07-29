//
//  OMNOrder.m
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"
#import "OMNOperationManager.h"

@implementation OMNOrder {
  id _data;
}

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    _data = jsonData;
    self.ID = jsonData[@"id"];
    self.amount = [jsonData[@"amount"] longLongValue];
    self.created = jsonData[@"created"];
    self.Description = jsonData[@"description"];
    self.notes = jsonData[@"notes"];
    self.status = jsonData[@"status"];
    self.openTime = jsonData[@"openTime"];
    self.modifiedTime = jsonData[@"modifiedTime"];
    self.restaurant_id = jsonData[@"restaurantId"];
    self.tableId = jsonData[@"tableId"];
    
    NSArray *itemsData = jsonData[@"items"];
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

- (void)createBill:(OMNBillBlock)completion failure:(OMNErrorBlock)failureBlock {
  
  NSString *description = @"";
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_data options:0 error:&error];
  
  if (jsonData &&
      nil == error) {
    description = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    description = [description stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  }
  description = @"на тебе кебаб";
  
  NSDictionary *parameters =
  @{
    @"description" : description,
    @"amount": @(self.toPayAmount),
    @"restaurant_id" : self.restaurant_id,
    @"restaurateur_order_id" : self.ID,
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
    
    failureBlock(error);
    
  }];
  
}

@end
