//
//  OMNLunchRestaurantMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLunchRestaurantMediator.h"
#import "OMNLunchPreorderMediator.h"
#import "OMNLaunchHandler.h"
#import "OMNSuncityLunchPreorderMediator.h"

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

- (OMNPreorderMediator *)preorderMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC {
#if LUNCH_2GIS_SUNCITY
  return [[OMNSuncityLunchPreorderMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
#else
  return [[OMNLunchPreorderMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
#endif
}

- (void)checkStartConditions {
  
  if ([OMNLaunchHandler sharedHandler].launchOptions.showRecommendations) {
    
    [OMNLaunchHandler sharedHandler].launchOptions.showRecommendations = NO;
    [self showPreorders];
    
  }
  
}

@end
