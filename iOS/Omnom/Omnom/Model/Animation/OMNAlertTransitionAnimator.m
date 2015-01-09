//
//  OMNAlertTransitionAnimator.m
//  omnom
//
//  Created by tea on 03.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAlertTransitionAnimator.h"
#import "OMNModalAlertVC.h"

@implementation OMNAlertTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.5;
  
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *fromView = fromVC.view;
  UIView *toView = toVC.view;
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  if (self.presenting) {
    
    OMNModalAlertVC *paymentAlertVC = (OMNModalAlertVC *)toVC;
    
    fromView.userInteractionEnabled = NO;
    
    UIView *snapshotView = [fromView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [transitionContext finalFrameForViewController:toVC];
    [containerView addSubview:snapshotView];
    
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    [containerView addSubview:toView];
    
    paymentAlertVC.alertView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(toView.frame));
    paymentAlertVC.fadeView.alpha = 0.0f;
    
    [UIView animateWithDuration:duration animations:^{
      
      fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
      paymentAlertVC.alertView.transform = CGAffineTransformIdentity;
      paymentAlertVC.fadeView.alpha = 1.0f;
      
    } completion:^(BOOL finished) {
      
      [snapshotView removeFromSuperview];
      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
      
    }];
    
  }
  else {
    
    OMNModalAlertVC *paymentAlertVC = (OMNModalAlertVC *)fromVC;
    
    [UIView animateWithDuration:duration animations:^{
      
      toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
      paymentAlertVC.alertView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(toView.frame));
      paymentAlertVC.fadeView.alpha = 0.0f;
      
    } completion:^(BOOL finished) {
      
      toView.userInteractionEnabled = YES;
      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
      
    }];
    
  }
}

@end
