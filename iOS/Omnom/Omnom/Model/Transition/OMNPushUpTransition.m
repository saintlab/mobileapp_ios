//
//  OMNPushUpTransition.m
//  omnom
//
//  Created by tea on 15.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPushUpTransition.h"
#import "OMNSearchRestaurantsVC.h"
#import "OMNRestaurantListVC.h"

@implementation OMNPushUpTransition

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNRestaurantListVC class]],
           ];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  // Get a snapshot of the thing cell we're transitioning from
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the image view
  UIView *fromImageSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
  fromViewController.view.hidden = YES;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:fromImageSnapshot];
  [containerView addSubview:toViewController.view];

  
  toViewController.view.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(fromImageSnapshot.frame));
  [toViewController.navigationController setNavigationBarHidden:YES animated:NO];
  
  [UIView animateWithDuration:duration animations:^{
    
    toViewController.view.transform = CGAffineTransformIdentity;
    
  } completion:^(BOOL finished) {
    // Clean up
    [toViewController.navigationController setNavigationBarHidden:NO animated:YES];
    [fromImageSnapshot removeFromSuperview];
    fromViewController.view.hidden = NO;
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.5;
  
}

@end
