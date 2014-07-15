//
//  UINavigationController+omn_replace.m
//  restaurants
//
//  Created by tea on 28.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UINavigationController+omn_replace.h"

@implementation UINavigationController (omn_replace)

- (void)omn_replaceCurrentViewControllerWithController:(UIViewController *)viewController animated:(BOOL)animated {
  
  NSMutableArray *currentControllers = [NSMutableArray arrayWithArray:self.viewControllers];
  [currentControllers removeLastObject];
  [currentControllers addObject:viewController];
  [self setViewControllers:currentControllers animated:animated];
  
}

@end
