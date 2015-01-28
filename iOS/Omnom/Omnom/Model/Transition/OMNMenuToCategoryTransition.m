//
//  OMNMenuToCategoryTransition.m
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuToCategoryTransition.h"
#import "OMNMenuVC.h"
#import "OMNMenuCategoryVC.h"
#import "UIView+frame.h"

@implementation OMNMenuToCategoryTransition

+ (NSArray *)keys {
  return @[[self keyFromClass:[OMNMenuVC class] toClass:[OMNMenuCategoryVC class]]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNMenuVC *fromViewController = (OMNMenuVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNMenuCategoryVC *toViewController = (OMNMenuCategoryVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the thing cell we're transitioning from
  

  UITableViewCell *cell = [fromViewController.tableView cellForRowAtIndexPath:[fromViewController.tableView indexPathForSelectedRow]];

  CGRect cellFrame = [fromViewController.tableView convertRect:[fromViewController.tableView rectForRowAtIndexPath:[fromViewController.tableView indexPathForSelectedRow]] toView:fromViewController.view];
  
  UIView *cellSnapshot = [cell.contentView snapshotViewAfterScreenUpdates:NO];
  cellSnapshot.frame = cellFrame;
  cell.contentView.hidden = YES;
  
  // Setup the initial view states
  CGRect toViewControllerFrame = CGRectMake(cellFrame.origin.x, CGRectGetMinY(cellFrame), CGRectGetWidth(cellFrame), CGRectGetHeight(cellFrame));
  toViewController.view.clipsToBounds = YES;
  toViewController.view.frame = toViewControllerFrame;
  toViewController.backgroundView.alpha = 0.0f;
  toViewController.view.backgroundColor = [UIColor clearColor];
  [containerView addSubview:toViewController.view];
  [containerView addSubview:cellSnapshot];

  
  [UIView animateWithDuration:duration animations:^{

    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    cellSnapshot.alpha = 0.0f;
    cellSnapshot.top = 20.0f;
    
  } completion:^(BOOL finished) {
    // Clean up
    cell.contentView.hidden = NO;
    [cellSnapshot removeFromSuperview];
    toViewController.backgroundView.alpha = 1.0f;
    toViewController.view.backgroundColor = [UIColor whiteColor];

    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.5;
  
}

@end
