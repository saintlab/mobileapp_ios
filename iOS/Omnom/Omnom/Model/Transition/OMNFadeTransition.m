//
//  OMNFadeTransition.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNFadeTransition.h"
#import "OMNSearchBeaconVC.h"
#import "OMNSearchBeaconRootVC.h"

@implementation OMNFadeTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNSearchBeaconVC *fromViewController = (OMNSearchBeaconVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNSearchBeaconRootVC *toViewController = (OMNSearchBeaconRootVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the image view
  UIView *fromImageSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
  fromImageSnapshot.frame = [transitionContext finalFrameForViewController:toViewController];
  
  fromViewController.view.hidden = YES;
  toViewController.view.alpha = 0.0f;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
  [containerView addSubview:fromImageSnapshot];
  
  [UIView animateWithDuration:duration animations:^{
    fromImageSnapshot.alpha = 0.0f;
    toViewController.view.alpha = 1.0f;
    
  } completion:^(BOOL finished) {
    
    // Clean up
    [fromImageSnapshot removeFromSuperview];
    fromViewController.view.hidden = NO;
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNSearchBeaconRootVC class]],
           [self keyFromClass:[OMNSearchBeaconRootVC class] toClass:[OMNSearchBeaconVC class]]
           ];
}

@end
