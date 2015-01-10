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
    [containerView addSubview:toView];
    
    paymentAlertVC.alertView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(toView.frame));
    paymentAlertVC.fadeView.alpha = 0.0f;
    
    [UIView animateWithDuration:duration animations:^{
      
      paymentAlertVC.alertView.transform = CGAffineTransformIdentity;
      paymentAlertVC.fadeView.alpha = 1.0f;
      
    } completion:^(BOOL finished) {
      
      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
      
    }];
    
  }
  else {
    
    OMNModalAlertVC *paymentAlertVC = (OMNModalAlertVC *)fromVC;
    
    [UIView animateWithDuration:duration animations:^{
      
      paymentAlertVC.alertView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(toView.frame));
      paymentAlertVC.fadeView.alpha = 0.0f;
      
    } completion:^(BOOL finished) {
      
      toView.userInteractionEnabled = YES;
      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
      
    }];
    
  }
}

@end
