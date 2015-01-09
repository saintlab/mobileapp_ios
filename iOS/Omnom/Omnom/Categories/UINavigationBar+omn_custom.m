//
//  UINavigationBar+omn_custom.m
//  omnom
//
//  Created by tea on 08.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "UINavigationBar+omn_custom.h"

@implementation UINavigationBar (omn_custom)

- (void)omn_setTransparentBackground {
  
  [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  [self setShadowImage:[UIImage new]];
  
}

- (void)omn_setDefaultBackground {

  [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
  [self setShadowImage:nil];
  
}

@end
