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
#import "OMNOrderItemCell.h"
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
  UIView *imageSnapshot = [fromViewController.tableView snapshotViewAfterScreenUpdates:NO];
  imageSnapshot.frame = [containerView convertRect:fromViewController.tableView.frame fromView:fromViewController.tableView.superview];
  fromViewController.tableView.hidden = YES;
  
  // Get the cell we'll animate to
  OMNOrderItemCell *cell = (OMNOrderItemCell *)[toViewController.collectionView cellForItemAtIndexPath:[toViewController.collectionView indexPathsForSelectedItems].firstObject];
  cell.hidden = YES;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
  [containerView addSubview:imageSnapshot];
  
  [UIView animateWithDuration:duration animations:^{
    // Fade out the source view controller
    fromViewController.view.alpha = 0.0;
    
    // Move the image view
    imageSnapshot.frame = [containerView convertRect:cell.frame fromView:cell.superview];
  } completion:^(BOOL finished) {
    // Clean up
    [imageSnapshot removeFromSuperview];
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
