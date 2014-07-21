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

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNSearchTableVC class] toClass:[OMNOrdersVC class]]
           ];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNSearchTableVC *fromViewController = (OMNSearchTableVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNOrdersVC *toViewController = (OMNOrdersVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the image view
  UIView *imageSnapshot = [fromViewController.imageView snapshotViewAfterScreenUpdates:NO];
  imageSnapshot.frame = [containerView convertRect:fromViewController.imageView.frame fromView:fromViewController.imageView.superview];
  fromViewController.imageView.hidden = YES;
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  
  [toViewController.collectionView reloadItemsAtIndexPaths:@[indexPath]];

  // Get the cell we'll animate to
  OMNOrderItemCell *cell = (OMNOrderItemCell *)[toViewController.collectionView cellForItemAtIndexPath:indexPath];
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
  [containerView addSubview:imageSnapshot];
  
  CGRect cellFrame = cell.frame;
  cellFrame.origin.y += 31.0f;
  
  cell.frame = [containerView convertRect:imageSnapshot.frame fromView:imageSnapshot.superview];
  cell.alpha = 0.0f;
  
  [UIView animateWithDuration:duration animations:^{
    // Fade out the source view controller
    fromViewController.view.alpha = 0.0;
    imageSnapshot.alpha = 0.0f;
    cell.alpha = 1.0f;

    imageSnapshot.frame = [containerView convertRect:cellFrame fromView:cell.superview];
    cell.frame = cellFrame;
    
  } completion:^(BOOL finished) {
    // Clean up
    [imageSnapshot removeFromSuperview];
    fromViewController.imageView.hidden = NO;

    fromViewController.view.alpha = 1.0;
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

@end
