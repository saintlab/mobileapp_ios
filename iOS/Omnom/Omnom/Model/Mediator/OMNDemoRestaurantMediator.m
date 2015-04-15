//
//  OMNDemoRestaurantMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNDemoRestaurantMediator.h"
#import "OMNLightBackgroundButton.h"

@implementation OMNDemoRestaurantMediator

- (UIBarButtonItem *)exitRestaurantButton {
  
  OMNLightBackgroundButton *cancelButton = [[OMNLightBackgroundButton alloc] init];
  [cancelButton setTitle:kOMN_EXIT_DEMO_BUTTON_TITLE forState:UIControlStateNormal];
  [cancelButton addTarget:self action:@selector(exitRestaurant) forControlEvents:UIControlEventTouchUpInside];
  return [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
  
}

- (UIButton *)userProfileButton {
  return nil;
}

- (BOOL)showTableButton {
  return NO;
}

- (void)didFinishPayment {
  [self exitRestaurant];
}

@end
