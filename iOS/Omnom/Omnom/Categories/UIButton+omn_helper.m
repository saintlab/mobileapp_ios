//
//  UIButton+omn_helper.m
//  omnom
//
//  Created by tea on 03.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UIButton+omn_helper.h"
#import "UIImage+omn_helper.h"

@implementation UIButton (omn_helper)

- (void)omn_setImage:(UIImage *)image withColor:(UIColor *)color {
  
  UIImage *templateImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self setImage:[templateImage omn_tintWithColor:color] forState:UIControlStateNormal];
  [self setImage:[templateImage omn_tintWithColor:[color colorWithAlphaComponent:0.5f]] forState:UIControlStateHighlighted];
  
}

- (void)omn_centerButtonAndImageWithSpacing:(CGFloat)spacing {
  
  CGFloat insetAmount = spacing / 2.0f;
  self.imageEdgeInsets = UIEdgeInsetsMake(0.0f, -insetAmount, 0.0f, insetAmount);
  self.titleEdgeInsets = UIEdgeInsetsMake(0.0f, insetAmount, 0.0f, -insetAmount);
  self.contentEdgeInsets = UIEdgeInsetsMake(0.0f, insetAmount, 0.0f, insetAmount);
  
}

@end
