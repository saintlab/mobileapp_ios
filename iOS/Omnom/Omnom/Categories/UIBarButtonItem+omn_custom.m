//
//  UIBarButtonItem+omn_custom.m
//  omnom
//
//  Created by tea on 09.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UIBarButtonItem+omn_custom.h"
#import "UIImage+omn_helper.h"
#import "OMNConstants.h"

@implementation UIBarButtonItem (omn_custom)

+ (UIButton *)omn_buttonWithImage:(UIImage *)image color:(UIColor *)color target:(id)target action:(SEL)action {
  
  return [self omn_buttonWithTitle:nil image:image color:color target:target action:action];
  
}

+ (UIButton *)omn_buttonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action {
  
  return [self omn_buttonWithTitle:title image:nil color:color target:target action:action];
  
}

+ (UIButton *)omn_buttonWithTitle:(NSString *)title image:(UIImage *)image color:(UIColor *)color target:(id)target action:(SEL)action {
  
  UIImage *templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
  UIButton *button = [[UIButton alloc] init];
  UIColor *highlitedColor = [color colorWithAlphaComponent:0.5f];
  [button setImage:[templateImage omn_tintWithColor:color] forState:UIControlStateNormal];
  [button setImage:[templateImage omn_tintWithColor:highlitedColor] forState:UIControlStateHighlighted];
  [button setImage:[templateImage omn_tintWithColor:highlitedColor] forState:UIControlStateDisabled];
  button.titleLabel.font = FuturaOSFOmnomRegular(20.0f);
  [button setTitleColor:color forState:UIControlStateNormal];
  [button setTitleColor:highlitedColor forState:UIControlStateHighlighted];
  [button setTitleColor:highlitedColor forState:UIControlStateDisabled];
  [button setTitle:title forState:UIControlStateNormal];
  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  [button sizeToFit];
  
  return button;
  
}

+ (UIBarButtonItem *)omn_loadingItem {
  
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner startAnimating];
  return [[UIBarButtonItem alloc] initWithCustomView:spinner];
  
}

+ (UIBarButtonItem *)omn_flexibleItem {
  
  return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  
}

+ (UIBarButtonItem *)omn_fixedItemWithSpace:(CGFloat)space {
  
  UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
  barButtonItem.width = space;
  return barButtonItem;
  
}

+ (UIBarButtonItem *)omn_barButtonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action {
  
  UIButton *button = [self omn_buttonWithTitle:title image:nil color:color target:target action:action];
  return [[UIBarButtonItem alloc] initWithCustomView:button];

}

+ (UIBarButtonItem *)omn_barButtonWithImage:(UIImage *)image color:(UIColor *)color target:(id)target action:(SEL)action {
  
  UIButton *button = [self omn_buttonWithTitle:nil image:image color:color target:target action:action];
  return [[UIBarButtonItem alloc] initWithCustomView:button];
  
}

@end
