//
//  OMNLunchRestaurantMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLunchRestaurantMediator.h"
#import "OMNLaunchHandler.h"
#import "OMN2GISLunchWishMediator.h"
#import "OMNSuncityLunchWishMediator.h"
#import "OMNPaidLunchWishMediator.h"

@implementation OMNLunchRestaurantMediator

- (UIBarButtonItem *)exitRestaurantButton {

#if LUNCH_2GIS
  return nil;
#elif LUNCH_2GIS_SUNCITY
  return nil;
#else
  return [super exitRestaurantButton];
#endif

}

- (BOOL)showTableButton {
  return NO;
}

- (BOOL)showPreorderButton {
  return YES;
}

- (OMNWishMediator *)wishMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC {
#if LUNCH_2GIS_SUNCITY
  return [[OMNSuncityLunchWishMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
#elif LUNCH_2GIS
  return [[OMN2GISLunchWishMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
#else
  return [[OMNPaidLunchWishMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
#endif
  
}

- (void)checkStartConditions {
  
  if ([OMNLaunchHandler sharedHandler].launch.showRecommendations) {
    
    [OMNLaunchHandler sharedHandler].launch.showRecommendations = NO;
    [self showPreorders];
    
  }
  else {
    
    [super checkStartConditions];
    
  }
  
}

@end
