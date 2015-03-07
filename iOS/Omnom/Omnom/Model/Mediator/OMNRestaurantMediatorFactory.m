//
//  OMNRestaurantMediatorFactory.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantMediatorFactory.h"
#import "OMNBarRestaurantMediator.h"
#import "OMNDemoRestaurantMediator.h"
#import "OMNLunchRestaurantMediator.h"

@implementation OMNRestaurantMediatorFactory

+ (OMNRestaurantMediator *)mediatorWithRestaurant:(OMNRestaurant *)restaurant rootViewController:(OMNRestaurantActionsVC *)restaurantActionsVC {
  
  OMNRestaurantMediator *restaurantMediator = nil;
  
  if (restaurant.is_demo) {
    return [[OMNDemoRestaurantMediator alloc] initWithRestaurant:restaurant rootViewController:restaurantActionsVC];
  }
  
  switch (restaurant.entrance_mode) {
    case kRestaurantModeBar: {
      
      restaurantMediator = [[OMNBarRestaurantMediator alloc] initWithRestaurant:restaurant rootViewController:restaurantActionsVC];
      
    } break;
    case kRestaurantModeLunch: {
      
      restaurantMediator = [[OMNLunchRestaurantMediator alloc] initWithRestaurant:restaurant rootViewController:restaurantActionsVC];
      
    } break;
    default: {
      
      restaurantMediator = [[OMNRestaurantMediator alloc] initWithRestaurant:restaurant rootViewController:restaurantActionsVC];
      
    } break;
      
  }
  
  return restaurantMediator;
  
}

@end
