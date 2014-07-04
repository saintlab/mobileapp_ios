//
//  OMNTransitionFromListToProduct.m
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTransitionFromListToProduct.h"
#import "OMNRestaurantMenuVC.h"
#import "OMNProductDetailsVC.h"
#import "OMNStubProductCell.h"

@implementation OMNTransitionFromListToProduct {

}

+ (NSString *)key {
  return [self keyFromClass:[OMNRestaurantMenuVC class] toClass:[OMNProductDetailsVC class]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

  OMNRestaurantMenuVC *fromViewController = (OMNRestaurantMenuVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNProductDetailsVC *toViewController = (OMNProductDetailsVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the thing cell we're transitioning from
  
  OMNStubProductCell *cell = (OMNStubProductCell *)[fromViewController.productsView cellForItemAtIndexPath:[fromViewController.productsView indexPathsForSelectedItems].firstObject];
  
  UIView *cellImageSnapshot = [cell.iconView snapshotViewAfterScreenUpdates:NO];
  cellImageSnapshot.frame = [containerView convertRect:cell.iconView.frame fromView:cell.iconView.superview];
  cell.iconView.hidden = YES;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  toViewController.view.alpha = 0;
  toViewController.imageView.hidden = YES;
  
  [containerView addSubview:toViewController.view];
  [containerView addSubview:cellImageSnapshot];
  
  [UIView animateWithDuration:duration animations:^{
    // Fade in the second view controller's view
    toViewController.view.alpha = 1.0;
    
    // Move the cell snapshot so it's over the second view controller's image view
    CGRect frame = [containerView convertRect:toViewController.imageView.frame fromView:toViewController.view];
    cellImageSnapshot.frame = frame;
  } completion:^(BOOL finished) {
    // Clean up
    toViewController.imageView.hidden = NO;
    cell.iconView.hidden = NO;
    [cellImageSnapshot removeFromSuperview];
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

@end
