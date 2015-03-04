//
//  OMNOrder+network.m
//  omnom
//
//  Created by tea on 07.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder+network.h"
#import "OMNOperationManager.h"

@implementation OMNOrder (network)

- (void)createBill:(OMNBillBlock)completionBlock failure:(void (^)(OMNError *error))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"amount": @(self.enteredAmount),
    @"tip_amount": @(self.tipAmount),
    @"restaurant_id" : self.restaurant_id,
    @"restaurateur_order_id" : self.id,
    @"table_id" : self.table_id,
    @"description" : @"",
    };
  
  [[OMNOperationManager sharedManager] POST:@"/bill" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      
      NSString *status = responseObject[@"status"];
      if ([status isEqualToString:@"new"]) {
        
        OMNBill *bill = [[OMNBill alloc] initWithJsonData:responseObject];
        completionBlock(bill);
        
      }
      else if ([status isEqualToString:@"paid"] ||
               [status isEqualToString:@"order_closed"]) {
        
        failureBlock([OMNError omnomErrorFromCode:kOMNErrorOrderClosed]);
        
      }
      else if ([status isEqualToString:@"restaurant_not_available"]) {
        
        failureBlock([OMNError omnomErrorFromCode:kOMNErrorRestaurantUnavailable]);
        
      }
      else {

        failureBlock([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
        
      }

    }
    else {
      
      failureBlock([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (void)billCall:(dispatch_block_t)completionBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders/%@/bill/call", self.restaurant_id, self.table_id, self.id];
  
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"status"]) {
      completionBlock();
    }
    else {
      failureBlock([NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : [responseObject description]}]);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
}

- (void)billCallStop:(dispatch_block_t)completionBlock failure:(void (^)(NSError *error))failureBlock {
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders/%@/bill/call/stop", self.restaurant_id, self.table_id, self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"status"]) {
      completionBlock();
    }
    else {
      failureBlock([NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : [responseObject description]}]);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
}

@end

@implementation NSArray (omn_restaurants)

- (NSArray *)omn_decodeOrdersWithError:(NSError **)error {
  
  NSMutableArray *orders = [NSMutableArray arrayWithCapacity:[self count]];
  for (id orderData in self) {
    
    OMNOrder *order = [[OMNOrder alloc] initWithJsonData:orderData];
    [orders addObject:order];
    
  }
  
  return [orders copy];
  
}

@end
