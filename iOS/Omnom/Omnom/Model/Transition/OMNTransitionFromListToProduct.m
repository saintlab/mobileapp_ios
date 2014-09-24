//
//  OMNTransitionFromListToProduct.m
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTransitionFromListToProduct.h"
#import "OMNRestaurantInfoVC.h"
#import "OMNProductDetailsVC.h"
#import "OMNRestaurantFeedItemCell.h"

@implementation OMNTransitionFromListToProduct {

}

+ (NSArray *)keys {
  return @[[self keyFromClass:[OMNRestaurantInfoVC class] toClass:[OMNProductDetailsVC class]]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

  OMNRestaurantInfoVC *fromViewController = (OMNRestaurantInfoVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNProductDetailsVC *toViewController = (OMNProductDetailsVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the thing cell we're transitioning from
  
  
  OMNRestaurantFeedItemCell *cell = (OMNRestaurantFeedItemCell *)[fromViewController.tableView cellForRowAtIndexPath:[fromViewController.tableView indexPathForSelectedRow]];
  
  UIImageView *cellImageSnapshot = [[UIImageView alloc] initWithFrame:[containerView convertRect:cell.iconView.frame fromView:cell.iconView.superview]];
  cellImageSnapshot.image = cell.iconView.image;
  cellImageSnapshot.clipsToBounds = YES;
  cellImageSnapshot.contentMode = cell.iconView.contentMode;
  cell.iconView.hidden = YES;
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  toViewController.view.alpha = 0;
  
  toViewController.imageView.hidden = YES;

  [containerView addSubview:toViewController.view];
  [containerView addSubview:cellImageSnapshot];

  [toViewController.view layoutIfNeeded];
  
  [UIView animateWithDuration:duration animations:^{
    // Fade in the second view controller's view
    toViewController.view.alpha = 1.0;
    
    // Move the cell snapshot so it's over the second view controller's image view
    CGRect frame = [containerView convertRect:toViewController.imageView.frame fromView:toViewController.imageView];
    cellImageSnapshot.frame = frame;
    cellImageSnapshot.contentMode = toViewController.imageView.contentMode;
    
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
