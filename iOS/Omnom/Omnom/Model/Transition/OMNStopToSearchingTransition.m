//
//  OMNStopToLaderTransition.m
//  omnom
//
//  Created by tea on 25.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStopToSearchingTransition.h"
#import "OMNAskNavigationPermissionsVC.h"
#import "OMNSearchBeaconVC.h"
#import "OMNTablePositionVC.h"

@implementation OMNStopToSearchingTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNBackgroundVC *fromViewController = (OMNBackgroundVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNSearchBeaconVC *toViewController = (OMNSearchBeaconVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
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
    //    [fromImageSnapshot removeFromSuperview];
    fromViewController.view.hidden = NO;
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.5;
}

+ (NSArray *)keys {
  return
  @[
    [self keyFromClass:[OMNAskNavigationPermissionsVC class] toClass:[OMNSearchBeaconVC class]],
    [self keyFromClass:[OMNSearchBeaconRootVC class] toClass:[OMNSearchBeaconVC class]],
    [self keyFromClass:[OMNTablePositionVC class] toClass:[OMNSearchBeaconVC class]],
    ];
}

@end