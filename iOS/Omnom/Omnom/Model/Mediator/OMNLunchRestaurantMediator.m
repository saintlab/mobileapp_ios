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

@implementation OMNLunchRestaurantMediator

- (UIBarButtonItem *)exitRestaurantButton {
  return nil;
}

- (BOOL)showTableButton {
  return NO;
}

- (BOOL)showPreorderButton {
  return YES;
}

- (OMNPreorderMediator *)preorderMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC {
  return [[OMNLunchPreorderMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
}

- (void)checkStartConditions {
  
  if ([OMNLaunchHandler sharedHandler].launchOptions.showRecommendations) {
    
    [OMNLaunchHandler sharedHandler].launchOptions.showRecommendations = NO;
    [self showPreorders];
    
  }
  
}

@end
