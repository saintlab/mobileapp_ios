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

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    _data = data;
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
  
  NSString *description = @"";
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_data options:0 error:&error];
  
  if (jsonData &&
      nil == error) {
    description = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    description = [description stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  }
  description = @"на тебе кебаб";
  
  NSDictionary *order =
  @{
    @"description" : description,
    @"amount": @(self.toPayAmount),
    @"restaurant_id" : self.restaurant_id,
    @"restaurateur_order_id" : self.ID,
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
