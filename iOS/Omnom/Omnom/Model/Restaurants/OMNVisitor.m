//
//  OMNVisitor.m
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNVisitor.h"
#import "OMNRestaurantMediator.h"

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

- (OMNRestaurantMediator *)mediatorWithRootVC:(OMNRestaurantActionsVC *)rootVC {
  return [[OMNRestaurantMediator alloc] initWithVisitor:self rootViewController:rootVC];
}

- (PMKPromise *)enter:(UIViewController *)rootVC {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    fulfill(self);
    
  }];
}

- (NSString *)tags {
  return @"";
}
- (NSString *)restarantCardButtonTitle {
  return @"";
}
- (NSString *)restarantCardButtonIcon {
  return @"";
}

@end
