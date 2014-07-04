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

@implementation OMNTransitionFromOrdersToOrder

+ (NSString *)key {
  return [self keyFromClass:[OMNOrdersVC class] toClass:[OMNPayOrderVC class]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNOrdersVC *fromViewController = (OMNOrdersVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNPayOrderVC *toViewController = (OMNPayOrderVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the thing cell we're transitioning from
  
  NSIndexPath *selectedIndexPath = [fromViewController.collectionView indexPathsForSelectedItems].firstObject;
  UICollectionViewCell *cell = [fromViewController.collectionView cellForItemAtIndexPath:selectedIndexPath];
  
  UIView *cellImageSnapshot = [cell snapshotViewAfterScreenUpdates:NO];
  cellImageSnapshot.frame = [containerView convertRect:cell.frame fromView:cell.superview];
  cell.hidden = YES;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  toViewController.view.alpha = 0;
  toViewController.tableView.hidden = YES;
  
  [containerView addSubview:toViewController.view];
  [containerView addSubview:cellImageSnapshot];
  
  [UIView animateWithDuration:duration animations:^{
    // Fade in the second view controller's view
    toViewController.view.alpha = 1.0;
    
    // Move the cell snapshot so it's over the second view controller's image view
    CGRect frame = [containerView convertRect:toViewController.tableView.frame fromView:toViewController.view];
    cellImageSnapshot.frame = frame;
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
