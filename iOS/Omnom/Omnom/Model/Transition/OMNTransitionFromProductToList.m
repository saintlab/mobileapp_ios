//
//  OMNTransitionFromProductToList.m
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTransitionFromProductToList.h"
#import "OMNRestaurantInfoVC.h"
#import "OMNProductDetailsVC.h"
#import "OMNRestaurantFeedItemCell.h"

@implementation OMNTransitionFromProductToList

+ (NSArray *)keys {
  return @[[self keyFromClass:[OMNProductDetailsVC class] toClass:[OMNRestaurantInfoVC class]]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNProductDetailsVC *fromViewController = (OMNProductDetailsVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNRestaurantInfoVC *toViewController = (OMNRestaurantInfoVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the image view
  UIImageView *imageSnapshot = [[UIImageView alloc] initWithFrame:[containerView convertRect:fromViewController.imageView.frame fromView:fromViewController.imageView.superview]];
  imageSnapshot.image = fromViewController.imageView.image;
  imageSnapshot.clipsToBounds = YES;
  imageSnapshot.contentMode = fromViewController.imageView.contentMode;
  fromViewController.imageView.hidden = YES;
  
  // Get the cell we'll animate to
  OMNRestaurantFeedItemCell *cell = (OMNRestaurantFeedItemCell *)[toViewController cellForFeedItem:fromViewController.feedItem];
  cell.iconView.hidden = YES;

  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
  [containerView addSubview:imageSnapshot];
  
  [UIView animateWithDuration:duration animations:^{
    // Fade out the source view controller
    fromViewController.view.alpha = 0.0;
    
    // Move the image view
    imageSnapshot.contentMode = cell.iconView.contentMode;
    imageSnapshot.frame = [containerView convertRect:cell.iconView.frame fromView:cell.iconView];
    
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
  return 0.5;
}

@end
