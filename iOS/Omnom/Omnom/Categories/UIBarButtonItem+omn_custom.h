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


@end

@interface UIButton (omn_bar_button)

+ (instancetype)omn_barButtonWithImage:(UIImage *)image color:(UIColor *)color target:(id)target action:(SEL)action;
+ (instancetype)omn_barButtonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action;
+ (instancetype)omn_barButtonWithTitle:(NSString *)title image:(UIImage *)image color:(UIColor *)color target:(id)target action:(SEL)action;

@end
