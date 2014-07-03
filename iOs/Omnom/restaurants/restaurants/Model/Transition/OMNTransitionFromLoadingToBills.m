//
//  OMNTransitionFromLoadingToBills.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTransitionFromLoadingToBills.h"
#import "OMNSearchTableVC.h"
#import "OMNOrdersVC.h"
#import "OMNOrderItemCell.h"

@implementation OMNTransitionFromLoadingToBills

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNSearchTableVC *fromViewController = (OMNSearchTableVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNOrdersVC *toViewController = (OMNOrdersVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the image view
  UIView *imageSnapshot = [fromViewController.imageView snapshotViewAfterScreenUpdates:NO];
  imageSnapshot.frame = [containerView convertRect:fromViewController.imageView.frame fromView:fromViewController.imageView.superview];
  fromViewController.imageView.hidden = YES;
  
  [toViewController.collectionView reloadData];
  
  // Get the cell we'll animate to
  OMNOrderItemCell *cell = (OMNOrderItemCell *)[toViewController.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  cell.hidden = YES;
  
  NSLog(@"%@", toViewController.collectionView);
  
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
    fromViewController.imageView.hidden = NO;
    cell.hidden = NO;
    fromViewController.view.alpha = 1.0;
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

@end
