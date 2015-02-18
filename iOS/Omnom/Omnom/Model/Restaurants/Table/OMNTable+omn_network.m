//
//  OMNTable+omn_network.m
//  omnom
//
//  Created by tea on 30.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTable+omn_network.h"
#import "OMNOperationManager.h"
#import "OMNAnalitics.h"
#import "OMNOrder+network.h"

@implementation OMNTable (omn_network)

- (void)tableIn {

  if (self.id &&
      self.restaurant_id) {

    NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/in", self.restaurant_id, self.id];
    [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if (![responseObject omn_isSuccessResponse]) {
        
        [[OMNAnalitics analitics] logDebugEvent:@"ERROR_TABLE_IN" jsonRequest:path jsonResponse:responseObject];
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_TABLE_IN" jsonRequest:path responseOperation:operation];
      
    }];
    
  }

}

- (void)getProductItems:(OMNProductItemsBlock)productItemsBlock error:(void(^)(OMNError *error))errorBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/items", self.restaurant_id, self.id];
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:[response count]];
    [response enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
      
      if (item[@"id"]) {
        [items addObject:item[@"id"]];
      }
      
    }];
    
    productItemsBlock(items);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_GET_PRODUCT_ITEMS" jsonRequest:path responseOperation:operation];
    errorBlock([error omn_internetError]);
    
  }];
  
}

- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(OMNError *error))errorBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders", self.restaurant_id, self.id];
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    if ([response isKindOfClass:[NSArray class]]) {
      
      NSArray *ordersData = response;
      NSArray *orders = [ordersData omn_decodeOrdersWithError:nil];
      if (0 == orders.count) {
        
        [[OMNAnalitics analitics] logDebugEvent:@"NO_ORDERS" jsonRequest:path responseOperation:operation];
        
      }
      ordersBlock(orders);
      
    }
    else {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_GET_ORDERS" jsonRequest:path responseOperation:operation];
      errorBlock([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_GET_ORDERS" jsonRequest:path responseOperation:operation];
    errorBlock([error omn_internetError]);
    
  }];
  
}

- (void)waiterCallWithCompletion:(void(^)(OMNError *error))completionBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/waiter/call", self.restaurant_id, self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    if ([response omn_isSuccessResponse]) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"WAITER_CALL" parametrs:response];
      
    }
    completionBlock(nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    completionBlock([error omn_internetError]);
    
  }];
  
}

- (void)waiterCallStopWithFailure:(void(^)(OMNError *error))failureBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/waiter/call/stop", self.restaurant_id, self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"WAITER_CALL_DONE" parametrs:response];
    failureBlock(nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];

}

- (void)newGuestWithCompletion:(dispatch_block_t)completionBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/new/guest", self.restaurant_id, self.id];
  
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *ordersData) {
    
    completionBlock();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_NEW_GUEST" jsonRequest:path responseOperation:operation];
    completionBlock();
    
  }];
  
}

@end
