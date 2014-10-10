//
//  OMNSlideDownTransition.m
//  omnom
//
//  Created by tea on 20.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSlideDownTransition.h"
#import "OMNRestaurantInfoVC.h"
#import "OMNR1VC.h"

@implementation OMNSlideDownTransition

+ (NSArray *)keys {
  return @[[self keyFromClass:[OMNRestaurantInfoVC class] toClass:[OMNR1VC class]]];
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
  [containerView addSubview:toViewController.view];
  [containerView addSubview:fromImageSnapshot];
  
  toViewController.view.transform = CGAffineTransformMakeTranslation(0.0f, -CGRectGetHeight(fromViewController.view.frame));
  
  [UIView animateWithDuration:duration animations:^{
    
    toViewController.view.transform = CGAffineTransformIdentity;
    fromImageSnapshot.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(fromViewController.view.frame));
    
  } completion:^(BOOL finished) {
    // Clean up
    [fromImageSnapshot removeFromSuperview];

    toViewController.view.transform = CGAffineTransformIdentity;

    fromViewController.view.hidden = NO;
    fromViewController.view.transform = CGAffineTransformIdentity;
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.5;
}

@end
