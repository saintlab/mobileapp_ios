//
//  OMNSlideUpTransition.m
//  omnom
//
//  Created by tea on 20.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSlideUpTransition.h"
#import "OMNRestaurantInfoVC.h"
#import "OMNR1VC.h"

@implementation OMNSlideUpTransition 

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNR1VC class] toClass:[OMNRestaurantInfoVC class]],
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
  fromImageSnapshot.frame = [containerView convertRect:fromViewController.view.frame fromView:fromViewController.view.superview];
  fromViewController.view.hidden = YES;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
  [containerView addSubview:fromImageSnapshot];
  
  toViewController.view.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(fromImageSnapshot.frame));
  
  [UIView animateWithDuration:duration animations:^{

    toViewController.view.transform = CGAffineTransformIdentity;
    fromImageSnapshot.transform = CGAffineTransformMakeTranslation(0.0f, -CGRectGetHeight(fromImageSnapshot.frame));
    
  } completion:^(BOOL finished) {
    // Clean up
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
