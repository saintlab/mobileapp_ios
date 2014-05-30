//
//  GUserInfoTransitionDelegate.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GUserInfoTransitionDelegate.h"
#import "GUserInfoTransition.h"

@implementation GUserInfoTransitionDelegate

- (id <UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
presentingController:(UIViewController *)presenting
sourceController:(UIViewController *)source {
  return [GUserInfoTransition forwardTransition];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  
  return [GUserInfoTransition backwardTransition];
  
}

@end
