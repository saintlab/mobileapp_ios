//
//  OMNNavigationController.m
//  omnom
//
//  Created by tea on 22.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNavigationController.h"

@interface OMNNavigationController ()

@end

@implementation OMNNavigationController

- (UIViewController *)childViewControllerForStatusBarHidden {
  UIViewController *visibleViewController = self.topViewController;
  return visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
  UIViewController *visibleViewController = self.topViewController;
  return visibleViewController;
}

@end
