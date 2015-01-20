//
//  UIBarButtonItem+omn_custom.h
//  omnom
//
//  Created by tea on 09.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (omn_custom)

+ (UIBarButtonItem *)omn_barButtonWithImage:(UIImage *)image color:(UIColor *)color target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)omn_barButtonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)omn_loadingItem;
+ (UIBarButtonItem *)omn_flexibleItem;
+ (UIBarButtonItem *)omn_fixedItemWithSpace:(CGFloat)space;

+ (UIButton *)omn_buttonWithImage:(UIImage *)image color:(UIColor *)color target:(id)target action:(SEL)action;
+ (UIButton *)omn_buttonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;
+ (UIButton *)omn_buttonWithTitle:(NSString *)title image:(UIImage *)image color:(UIColor *)color target:(id)target action:(SEL)action;

@end
