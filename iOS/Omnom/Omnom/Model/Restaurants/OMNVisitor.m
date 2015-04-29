//
//  OMNVisitor.m
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNVisitor.h"
#import "OMNOperationManager.h"
#import "OMNAnalitics.h"

@interface OMNVisitor ()

@property (nonatomic, strong) OMNWish *wish;

@end

@implementation OMNVisitor

+ (instancetype)visitorWithRestaurant:(OMNRestaurant *)restaurant delivery:(OMNDelivery *)delivery {
  return [[[self class] alloc] initWithRestaurant:restaurant delivery:delivery];
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant delivery:(OMNDelivery *)delivery {
  self = [super init];
  if (self) {
    
    NSAssert(delivery != nil, @"delivery should not be nil");
    NSAssert(restaurant != nil, @"restaurant should not be nil");
    
    _restaurant = restaurant;
    _delivery = delivery;
    
  }
  return self;
}

- (instancetype)visitorWithWish:(OMNWish *)wish {
  
  OMNVisitor *vistor = [[OMNVisitor alloc] initWithRestaurant:self.restaurant delivery:self.delivery];
  vistor.wish = wish;
  return vistor;
  
}

- (OMNRestaurantMediator *)mediatorWithRootVC:(OMNRestaurantActionsVC *)rootVC {
  return [[OMNRestaurantMediator alloc] initWithVisitor:self rootViewController:rootVC];
}

- (PMKPromise *)createWish:(NSArray *)wishItems {
  
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (wishItems) {
      parameters[@"items"] = wishItems;
    }
    [parameters addEntriesFromDictionary:self.delivery.parameters];
    
    NSString *path = [NSString stringWithFormat:@"/restaurants/%@/wishes", self.restaurant.id];
    [[OMNOperationManager sharedManager] POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      OMNWish *wish = [[OMNWish alloc] initWithJsonData:responseObject];
      OMNVisitor *wishVisitor = [self visitorWithWish:wish];
      fulfill(wishVisitor);
      
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

- (NSDictionary *)menuParameters {
  return
  @{
    @"tags" : @"in",
    };
}

- (void)getMenuWithCompletion:(OMNMenuBlock)completion {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/menu", self.restaurant.id];
  @weakify(self)
  [[OMNOperationManager sharedManager] GET:path parameters:self.menuParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
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
