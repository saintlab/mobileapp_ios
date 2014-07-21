//
//  OMNTransitionFromProductToList.m
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTransitionFromProductToList.h"
#import "OMNRestaurantMenuVC.h"
#import "OMNProductDetailsVC.h"
#import "OMNStubProductCell.h"

@implementation OMNTransitionFromProductToList

+ (NSArray *)keys {
  return @[[self keyFromClass:[OMNProductDetailsVC class] toClass:[OMNRestaurantMenuVC class]]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNProductDetailsVC *fromViewController = (OMNProductDetailsVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNRestaurantMenuVC *toViewController = (OMNRestaurantMenuVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the image view
  UIView *imageSnapshot = [fromViewController.imageView snapshotViewAfterScreenUpdates:NO];
  imageSnapshot.frame = [containerView convertRect:fromViewController.imageView.frame fromView:fromViewController.imageView.superview];
  fromViewController.imageView.hidden = YES;
  
  // Get the cell we'll animate to
  OMNStubProductCell *cell = [toViewController collectionViewCellForProduct:fromViewController.product];
  cell.iconView.hidden = YES;

  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
  [containerView addSubview:imageSnapshot];
  
  [UIView animateWithDuration:duration animations:^{
    // Fade out the source view controller
    fromViewController.view.alpha = 0.0;
    
    // Move the image view
    imageSnapshot.frame = [containerView convertRect:cell.iconView.frame fromView:cell.iconView.superview];
  } completion:^(BOOL finished) {
    // Clean up
    [imageSnapshot removeFromSuperview];
    fromViewController.imageView.hidden = NO;
    cell.iconView.hidden = NO;
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

@end
