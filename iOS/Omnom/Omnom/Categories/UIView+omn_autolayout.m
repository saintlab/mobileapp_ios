//
//  UIView+omn_autolayout.m
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UIView+omn_autolayout.h"

@implementation UIView (omn_autolayout)

+ (instancetype)omn_autolayoutView {
  
  UIView *view = [[[self class] alloc] init];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  return view;
  
}

@end
