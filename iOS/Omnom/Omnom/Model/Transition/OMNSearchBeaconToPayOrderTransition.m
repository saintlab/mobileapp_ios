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
#import "OMNOrdersVC.h"
#import <OMNStyler.h>
#import "OMNPushPermissionVC.h"

@implementation OMNSearchBeaconToPayOrderTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNCircleRootVC *fromViewController = (OMNCircleRootVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];

  // Get a snapshot of the image view
  UIView *fromImageSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
  fromViewController.view.hidden = YES;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];

  [containerView addSubview:fromImageSnapshot];
  
  UIImage *circleBackground = [fromViewController.circleButton backgroundImageForState:UIControlStateNormal];
  UIImageView *bigCircleIV = [[UIImageView alloc] initWithFrame:fromViewController.circleButton.frame];
  bigCircleIV.image = circleBackground;
  [containerView addSubview:bigCircleIV];
  
  [containerView addSubview:toViewController.view];
  toViewController.view.transform = CGAffineTransformMakeTranslation(0.0f, -2*CGRectGetHeight(toViewController.view.frame));
  
  NSTimeInterval OrderSlideAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderSlideAnimationDuration"];
  NSTimeInterval CircleAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"CircleAnimationDuration"];
  
  CGFloat scale = 4.0f;
  
  [UIView animateWithDuration:CircleAnimationDuration animations:^{
    
    bigCircleIV.transform = CGAffineTransformMakeScale(scale, scale);
    
  } completion:^(BOOL finished) {
    
    [fromImageSnapshot removeFromSuperview];
    [UIView animateWithDuration:OrderSlideAnimationDuration animations:^{
      
      toViewController.view.transform = CGAffineTransformIdentity;
      
    } completion:^(BOOL finished) {
      
      [bigCircleIV removeFromSuperview];
      fromViewController.view.hidden = NO;
      [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
      
    }];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  NSTimeInterval OrderSlideAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderSlideAnimationDuration"];
  NSTimeInterval CircleAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"CircleAnimationDuration"];
  return OrderSlideAnimationDuration + CircleAnimationDuration;
}

+ (NSArray *)keys {
  return
  @[
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNPayOrderVC class]],
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNOrdersVC class]],
    [self keyFromClass:[OMNPushPermissionVC class] toClass:[OMNPayOrderVC class]],
    [self keyFromClass:[OMNPushPermissionVC class] toClass:[OMNOrdersVC class]],
    ];
}

@end
