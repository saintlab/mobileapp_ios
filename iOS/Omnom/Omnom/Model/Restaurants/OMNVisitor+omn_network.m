//
//  OMNVisitor+omn_network.m
//  omnom
//
//  Created by tea on 18.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNVisitor+omn_network.h"
#import "OMNOperationManager.h"
#import "OMNAnalitics.h"

@implementation OMNVisitor (omn_network)

- (PMKPromise *)createWish:(NSArray *)wishItems {
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  if (wishItems) {
    parameters[@"items"] = wishItems;
  }
  parameters[@"tags"] = self.tags;
  if (self.delivery) {
    parameters[@"comments"] = self.delivery.parameters;
  }
  
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    
    NSString *path = [NSString stringWithFormat:@"/restaurants/%@/wishes", self.restaurant.id];
    [[OMNOperationManager sharedManager] POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      OMNWish *wish = [[OMNWish alloc] initWithJsonData:responseObject];
      fulfill(wish);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      //    Формат - статус код 409, массив {"forbidden":[{"id":"-1"}]}
      if (409 == operation.response.statusCode) {
        
        id forbiddenWishProductsData = operation.responseObject[OMNForbiddenWishProductsKey];
        OMNForbiddenWishProducts *forbiddenWishProducts = [[OMNForbiddenWishProducts alloc] initWithJsonData:forbiddenWishProductsData];
        reject([OMNError errorWithDomain:OMNErrorDomain code:kOMNErrorForbiddenWishProducts userInfo:@{OMNForbiddenWishProductsKey : forbiddenWishProducts}]);
        
      }
      else {
        
        reject([operation omn_internetError]);
        
      }
      
    }];
    
  }];
  
}

- (void)getMenuWithCompletion:(OMNMenuBlock)completion {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/menu", self.restaurant.id];
  @weakify(self)
  [[OMNOperationManager sharedManager] GET:path parameters:@{@"tags" : self.tags} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject omn_isSuccessResponse]) {
      
      OMNMenu *menu = [[OMNMenu alloc] initWithJsonData:responseObject[@"menu"]];
      completion(menu);
      
    }
    else {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_MENU" jsonRequest:path responseOperation:operation];
      completion(nil);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_MENU" jsonRequest:path responseOperation:operation];
    @strongify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self getMenuWithCompletion:completion];
    });
    
  }];
  
}

@end
