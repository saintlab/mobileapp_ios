//
//  OMNBarRestaurantMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBarRestaurantMediator.h"
#import "OMNBarWishMediator.h"
#import "OMNLaunchHandler.h"
#import "UIBarButtonItem+omn_custom.h"

@implementation OMNBarRestaurantMediator

- (BOOL)showTableButton {
  return NO;
}

- (BOOL)showPreorderButton {
  return YES;
}

- (OMNWishMediator *)wishMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC {
  return [[OMNBarWishMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
}

- (void)checkStartConditions {
  
  if ([OMNLaunchHandler sharedHandler].launchOptions.showRecommendations) {
    
    [OMNLaunchHandler sharedHandler].launchOptions.showRecommendations = NO;
    [self showPreorders];
    
  }
  
}

- (UIView *)titleView {
  
  UIColor *color = self.restaurant.decoration.antagonist_color;
  UIButton *titleButton = [UIButton omn_barButtonWithTitle:kOMN_BAR_TITLE_BUTTON_TEXT color:color target:nil action:nil];
  titleButton.userInteractionEnabled = NO;
  return titleButton;
  
}

@end
