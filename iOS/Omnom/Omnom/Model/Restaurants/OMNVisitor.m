//
//  OMNVisitor.m
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNVisitor.h"
#import "OMNOperationManager.h"

@interface OMNVisitor ()

@property (nonatomic, strong) OMNWish *wish;

@end

@implementation OMNVisitor

- (void)dealloc
{
  
}

+ (instancetype)visitorWithRestaurant:(OMNRestaurant *)restaurant delivery:(OMNDelivery *)delivery {
  return [[[self class] alloc] initWithRestaurant:restaurant delivery:delivery];
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant delivery:(OMNDelivery *)delivery {
  self = [super init];
  if (self) {
    
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

- (NSMutableDictionary *)wishParametersWithItems:(NSArray *)items {
  
  NSMutableDictionary *wishParameters = [NSMutableDictionary dictionary];
  if (items) {
    wishParameters[@"items"] = items;
  }
  wishParameters[@"type"] = @"restaurant";
  return wishParameters;
  
}

- (void)createWish:(NSArray *)wishItems completionBlock:(OMNVisitorWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock {

  NSMutableDictionary *parameters = [self wishParametersWithItems:wishItems];
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/wishes", self.restaurant.id];
  [[OMNOperationManager sharedManager] POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    OMNWish *wish = [[OMNWish alloc] initWithJsonData:responseObject];
    completionBlock([self visitorWithWish:wish]);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    //    Формат - статус код 409, массив skip_id:[]
    if (409 == error.code) {
      
      wrongIDsBlock(operation.responseObject[@"skip_id"]);
      
    }
    else {
      
      failureBlock([error omn_internetError]);
      
    }
    
  }];
  
}

@end
