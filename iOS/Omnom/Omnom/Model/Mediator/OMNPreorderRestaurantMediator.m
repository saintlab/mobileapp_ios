//
//  OMNPreorderRestaurantMediator.m
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderRestaurantMediator.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNPreorderWishMediator.h"

@implementation OMNPreorderRestaurantMediator

- (BOOL)showTableButton {
  return NO;
}

- (BOOL)showPreorderButton {
  return YES;
}

- (OMNWishMediator *)wishMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC {
  return [[OMNPreorderWishMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
}

- (UIView *)titleView {
  
  UIColor *color = self.restaurant.decoration.antagonist_color;
  UIButton *titleButton = [UIButton omn_barButtonWithTitle:kOMN_PREORDER_TITLE_BUTTON_TEXT color:color target:nil action:nil];
  titleButton.userInteractionEnabled = NO;
  return titleButton;
  
}

@end
