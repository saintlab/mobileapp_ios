//
//  OMNBarRestaurantMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBarRestaurantMediator.h"
#import "OMNBarPreorderMediator.h"
#import "OMNLaunchHandler.h"

@implementation OMNBarRestaurantMediator

- (BOOL)showTableButton {
  return NO;
}

- (BOOL)showPreorderButton {
  return YES;
}

- (OMNPreorderMediator *)preorderMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC {
  return [[OMNBarPreorderMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
}

- (void)checkStartConditions {
  
  if ([OMNLaunchHandler sharedHandler].launchOptions.showRecommendations) {
    
    [OMNLaunchHandler sharedHandler].launchOptions.showRecommendations = NO;
    [self showPreorders];
    
  }
  
}

@end
