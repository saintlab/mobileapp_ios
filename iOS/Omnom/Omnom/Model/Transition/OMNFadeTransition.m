//
//  OMNFadeTransition.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNFadeTransition.h"
#import "OMNSearchBeaconVC.h"
#import "OMNCircleRootVC.h"
#import "OMNTablePositionVC.h"
#import "OMNR1VC.h"
#import "OMNStartVC.h"

@implementation OMNFadeTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNSearchBeaconVC *fromViewController = (OMNSearchBeaconVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNCircleRootVC *toViewController = (OMNCircleRootVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the image view
  UIView *fromImageSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
  fromImageSnapshot.frame = [transitionContext finalFrameForViewController:toViewController];
  
  fromViewController.view.hidden = YES;

  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:toViewController.view];
  [containerView addSubview:fromImageSnapshot];
  
  [UIView animateWithDuration:duration animations:^{
    fromImageSnapshot.alpha = 0.0f;
    
  } completion:^(BOOL finished) {
    
    // Clean up
    [fromImageSnapshot removeFromSuperview];
    fromViewController.view.hidden = NO;
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 2;
}

+ (NSArray *)keys {
  return @[
           ];
}

@end
