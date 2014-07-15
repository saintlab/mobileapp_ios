//
//  GUserInfoTransitionDelegate.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoTransitionDelegate.h"
#import "OMNUserInfoTransition.h"

@implementation OMNUserInfoTransitionDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
  return [OMNUserInfoTransition forwardTransitionWithComplition:self.didFinishBlock];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  
  return [OMNUserInfoTransition backwardTransition];
  
}

@end
