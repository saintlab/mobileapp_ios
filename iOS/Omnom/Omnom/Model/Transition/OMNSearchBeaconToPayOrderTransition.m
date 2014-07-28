//
//  OMNSearchBeaconToPayOrderTransition.m
//  omnom
//
//  Created by tea on 26.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchBeaconToPayOrderTransition.h"
#import "OMNSearchBeaconVC.h"
#import "OMNPayOrderVC.h"

@implementation OMNSearchBeaconToPayOrderTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNSearchBeaconVC *fromViewController = (OMNSearchBeaconVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNPayOrderVC *toViewController = (OMNPayOrderVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  
  // Get a snapshot of the image view
  UIView *fromImageSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
//  fromImageSnapshot.frame = [transitionContext finalFrameForViewController:toViewController];
  fromViewController.view.hidden = YES;
  
  UIImage *circleBackground = [fromViewController.circleButton backgroundImageForState:UIControlStateNormal];
  UIImageView *bigCircleIV = [[UIImageView alloc] initWithFrame:fromViewController.circleButton.frame];
  bigCircleIV.image = circleBackground;
  [fromImageSnapshot addSubview:bigCircleIV];
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];

  [containerView addSubview:fromImageSnapshot];
  [containerView addSubview:toViewController.view];
  toViewController.view.transform = CGAffineTransformMakeTranslation(0.0f, -2*CGRectGetHeight(toViewController.view.frame));
  
  CGFloat scale = 4.0f;
  
  [UIView animateWithDuration:0.5 animations:^{
    
    bigCircleIV.transform = CGAffineTransformMakeScale(scale, scale);
    
  } completion:^(BOOL finished) {
  }];
  
  
  [UIView animateWithDuration:1.0 delay:0.5 options:0 animations:^{
    
    toViewController.view.transform = CGAffineTransformIdentity;
    
  } completion:^(BOOL finished) {
    
    fromViewController.view.hidden = NO;
    [fromImageSnapshot removeFromSuperview];
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.5+1.0;
}

+ (NSArray *)keys {
  return
  @[
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNPayOrderVC class]],
    ];
}

@end
