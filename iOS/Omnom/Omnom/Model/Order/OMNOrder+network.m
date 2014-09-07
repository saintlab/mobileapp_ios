//
//  OMNOrder+network.m
//  omnom
//
//  Created by tea on 07.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder+network.h"
#import "OMNOperationManager.h"
#import "OMNAnalitics.h"

@implementation OMNOrder (network)

- (void)createBill:(OMNBillBlock)completion failure:(void (^)(NSError *error))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"amount": @(self.enteredAmount),
    @"restaurant_id" : self.restaurant_id,
    @"restaurateur_order_id" : self.id,
    @"table_id" : self.table_id,
    @"description" : @"",
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
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders/%@/bill/call", self.restaurant_id, self.table_id, self.id];
  
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"status"]) {
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
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders/%@/bill/call/stop", self.restaurant_id, self.table_id, self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"status"]) {
      completionBlock();
    }
    else {
      failureBlock([NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey : [responseObject description]}]);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
}

- (void)logPayment {
  
  [[OMNAnalitics analitics] logPayment:self];

}

@end
