//
//  OMNCalculatorTransition.m
//  restaurants
//
//  Created by tea on 23.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculatorTransition.h"
#import "OMNCalculatorVC.h"
#import "OMNPaymentVC.h"

@implementation OMNCalculatorTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNPaymentVC *fromViewController = (OMNPaymentVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNCalculatorVC *toViewController = (OMNCalculatorVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the thing cell we're transitioning from
  UITableView *fromTableView = fromViewController.tableView;
  UIView *cellImageSnapshot = [fromTableView snapshotViewAfterScreenUpdates:NO];
  cellImageSnapshot.frame = [containerView convertRect:fromTableView.frame fromView:fromTableView.superview];
  fromTableView.hidden = YES;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  toViewController.view.alpha = 0;
  toViewController.view.hidden = YES;
  
  [containerView addSubview:toViewController.view];
  [containerView addSubview:cellImageSnapshot];
  
  [UIView animateWithDuration:duration animations:^{
    // Fade in the second view controller's view
    toViewController.view.alpha = 1.0;
    
    // Move the cell snapshot so it's over the second view controller's image view
    CGRect frame = [containerView convertRect:toViewController.view.frame fromView:toViewController.view];
    cellImageSnapshot.frame = frame;
  } completion:^(BOOL finished) {
    // Clean up
    toViewController.view.hidden = NO;
    fromTableView.hidden = NO;
    [cellImageSnapshot removeFromSuperview];
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

@end
