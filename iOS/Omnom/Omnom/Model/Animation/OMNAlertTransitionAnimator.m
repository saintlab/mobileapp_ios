//
//  OMNAlertTransitionAnimator.m
//  omnom
//
//  Created by tea on 03.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAlertTransitionAnimator.h"
#import "OMNPaymentAlertVC.h"

@implementation OMNAlertTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
  return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  // Grab the from and to view controllers from the context
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  // Set our ending frame. We'll modify this later if we have to
  
  if (self.presenting) {
    
    OMNPaymentAlertVC *paymentAlertVC = (OMNPaymentAlertVC *)toViewController;
    
    fromViewController.view.userInteractionEnabled = NO;
    
    [transitionContext.containerView addSubview:fromViewController.view];
    [transitionContext.containerView addSubview:toViewController.view];
  
    toViewController.view.frame = fromViewController.view.frame;
    
    paymentAlertVC.containerView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(toViewController.view.frame));
    paymentAlertVC.fadeView.alpha = 0.0f;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
      
      fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
      paymentAlertVC.containerView.transform = CGAffineTransformIdentity;
      paymentAlertVC.fadeView.alpha = 1.0f;
      
    } completion:^(BOOL finished) {
      
      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
      
    }];
    
  }
  else {
    
    [transitionContext.containerView addSubview:toViewController.view];
    [transitionContext.containerView addSubview:fromViewController.view];
    
    OMNPaymentAlertVC *paymentAlertVC = (OMNPaymentAlertVC *)fromViewController;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
      
      toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
      
      paymentAlertVC.containerView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(fromViewController.view.frame));
      paymentAlertVC.fadeView.alpha = 0.0f;
      
    } completion:^(BOOL finished) {
      
      toViewController.view.userInteractionEnabled = YES;
      [fromViewController.view removeFromSuperview];
      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
      
    }];
    
  }
}

@end
