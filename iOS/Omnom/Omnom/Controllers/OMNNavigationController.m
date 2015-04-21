//
//  OMNNavigationController.m
//  omnom
//
//  Created by tea on 22.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNavigationController.h"
#import "OMNNavigationControllerDelegate.h"

@interface OMNNavigationController ()

@end

@implementation OMNNavigationController

+ (instancetype)controllerWithRootVC:(UIViewController *)rootVC {
  
  OMNNavigationController *navC = [[OMNNavigationController alloc] initWithRootViewController:rootVC];
  navC.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  return navC;
  
}

- (UIViewController *)childViewControllerForStatusBarHidden {
  UIViewController *visibleViewController = self.topViewController;
  return visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
  UIViewController *visibleViewController = self.topViewController;
  return visibleViewController;
}

@end
