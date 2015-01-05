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

#warning tableInWithFailure
//- (void)tableInWithFailure:(void(^)(NSError *error))failureBlock {
//
//  if (nil == self.table.id) {
//    return;
//  }
//
//  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/in", self.id, self.table.id];
//  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//    if ([responseObject[@"status"] isEqualToString:@"success"]) {
//
//      failureBlock(nil);
//
//    }
//    else {
//
//      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_TABLE_IN" jsonRequest:path jsonResponse:responseObject];
//      failureBlock(nil);
//
//    }
//
//  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_TABLE_IN" jsonRequest:path responseOperation:operation];
//    failureBlock(error);
//
//  }];
//
//}

- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock {
  
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
      errorBlock(nil);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_GET_ORDERS" jsonRequest:path responseOperation:operation];
    errorBlock(error);
    
  }];
  
}

@end
