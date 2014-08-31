//
//  OMNTransitionFromOrdersToOrder.m
//  restaurants
//
//  Created by tea on 02.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTransitionFromOrdersToOrder.h"
#import "OMNOrdersVC.h"
#import "OMNPayOrderVC.h"
#import "OMNOrderViewCell.h"

@implementation OMNTransitionFromOrdersToOrder

+ (NSArray *)keys {
  return @[[self keyFromClass:[OMNOrdersVC class] toClass:[OMNPayOrderVC class]]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNOrdersVC *fromViewController = (OMNOrdersVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNPayOrderVC *toViewController = (OMNPayOrderVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the thing cell we're transitioning from
  
  NSIndexPath *selectedIndexPath = [fromViewController.collectionView indexPathsForSelectedItems].firstObject;
  OMNOrderViewCell *cell = (OMNOrderViewCell *)[fromViewController.collectionView cellForItemAtIndexPath:selectedIndexPath];
  UIView *cellImageSnapshot = [cell snapshotViewAfterScreenUpdates:NO];
  cellImageSnapshot.frame = [containerView convertRect:cell.frame fromView:cell.superview];
  cell.hidden = YES;
  [toViewController.view layoutIfNeeded];
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  toViewController.view.alpha = 0;
  toViewController.tableView.hidden = YES;
  
  [containerView addSubview:toViewController.view];
  [containerView addSubview:cellImageSnapshot];
  
  
  [UIView animateWithDuration:duration animations:^{
    // Fade in the second view controller's view
    toViewController.view.alpha = 1.0;
    
    CGRect calulateFrame = [toViewController.tableView.tableFooterView convertRect:toViewController.tableView.tableFooterView.bounds toView:containerView];
    
    CGRect toFrame = cellImageSnapshot.frame;
    CGFloat aspect = calulateFrame.size.width/toFrame.size.width;
    toFrame.size.width = calulateFrame.size.width;
    toFrame.size.height *= aspect;
    toFrame.origin.x = 0.0f;
    toFrame.origin.y = CGRectGetMaxY(calulateFrame) - toFrame.size.height;
    cellImageSnapshot.frame = toFrame;
    
  } completion:^(BOOL finished) {
    // Clean up
    toViewController.tableView.hidden = NO;
    cell.hidden = NO;
    [cellImageSnapshot removeFromSuperview];
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

@end
