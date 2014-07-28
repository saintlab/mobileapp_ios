//
//  OMNRestaurantToSearchBeaconTransition.m
//  omnom
//
//  Created by tea on 26.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantToSearchBeaconTransition.h"
#import "OMNR1VC.h"
#import "OMNSearchBeaconVC.h"

@implementation OMNRestaurantToSearchBeaconTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNR1VC *fromViewController = (OMNR1VC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNSearchBeaconVC *toViewController = (OMNSearchBeaconVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  [toViewController.circleButton setBackgroundImage:[fromViewController.circleButton backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
  
  // Get a snapshot of the image view
  UIView *fromImageSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
  fromImageSnapshot.frame = [transitionContext finalFrameForViewController:toViewController];
  fromViewController.view.hidden = YES;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [toViewController.backgroundView addSubview:fromImageSnapshot];
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
  return 0.3;
}

+ (NSArray *)keys {
  return
  @[
    [self keyFromClass:[OMNR1VC class] toClass:[OMNSearchBeaconVC class]],
    ];
}

@end
