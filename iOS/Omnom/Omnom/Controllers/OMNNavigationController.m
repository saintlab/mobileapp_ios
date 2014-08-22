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

- (UIStatusBarStyle)preferredStatusBarStyle {
  return self.topViewController.preferredStatusBarStyle;
}

@end
