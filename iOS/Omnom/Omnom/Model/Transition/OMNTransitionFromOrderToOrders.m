//
//  OMNTransitionFromOrderToOrders.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTransitionFromOrderToOrders.h"
#import "OMNOrdersVC.h"
#import "OMNPayOrderVC.h"
#import "OMNOrderViewCell.h"
@implementation OMNTransitionFromOrderToOrders

+ (NSArray *)keys {
  return @[[self keyFromClass:[OMNPayOrderVC class] toClass:[OMNOrdersVC class]]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNPayOrderVC *fromViewController = (OMNPayOrderVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNOrdersVC *toViewController = (OMNOrdersVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  // Get a snapshot of the thing cell we're transitioning from
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the image view
  CGRect fromRect = [containerView convertRect:fromViewController.tableView.frame fromView:fromViewController.tableView.superview];
  UIView *moveView = [[UIView alloc] initWithFrame:fromRect];
  moveView.clipsToBounds = YES;
  [containerView addSubview:moveView];
  
  UIView *tableSnapshot = [fromViewController.tableView snapshotViewAfterScreenUpdates:NO];
  tableSnapshot.frame = moveView.bounds;
  tableSnapshot.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
  tableSnapshot.center = CGPointMake(CGRectGetMidX(moveView.bounds), CGRectGetHeight(moveView.bounds));
  [moveView addSubview:tableSnapshot];
  fromViewController.tableView.hidden = YES;
  
  // Get the cell we'll animate to
  OMNOrderViewCell *cell = (OMNOrderViewCell *)[toViewController.collectionView cellForItemAtIndexPath:[toViewController.collectionView indexPathsForSelectedItems].firstObject];
  cell.hidden = YES;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
//  [containerView addSubview:tableSnapshot];
  
  [UIView animateWithDuration:duration animations:^{
    // Fade out the source view controller
    fromViewController.view.alpha = 0.0;
    
    CGRect finalFrame = [cell.tableView convertRect:cell.tableView.bounds toView:containerView];
    CGFloat scale = CGRectGetWidth(finalFrame)/CGRectGetWidth(tableSnapshot.frame);
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    tableSnapshot.transform = CGAffineTransformMakeScale(scale, scale);
    tableSnapshot.center = CGPointMake(CGRectGetWidth(finalFrame)/2.0f, CGRectGetHeight(finalFrame));
    moveView.frame = finalFrame;

  } completion:^(BOOL finished) {
    // Clean up
    [moveView removeFromSuperview];
    fromViewController.tableView.hidden = NO;
    cell.hidden = NO;
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.5;
}

@end
