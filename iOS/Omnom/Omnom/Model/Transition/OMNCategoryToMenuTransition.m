//
//  OMNCategoryToMenuTransition.m
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNCategoryToMenuTransition.h"
#import "OMNMenuVC.h"
#import "OMNMenuCategoryVC.h"
#import "UIView+frame.h"

@implementation OMNCategoryToMenuTransition

+ (NSArray *)keys {
  return @[[self keyFromClass:[OMNMenuCategoryVC class] toClass:[OMNMenuVC class]]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNMenuCategoryVC *fromViewController = (OMNMenuCategoryVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNMenuVC *toViewController = (OMNMenuVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the thing cell we're transitioning from
  
  
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  UITableViewCell *cell = [toViewController.tableView cellForRowAtIndexPath:toViewController.selectedIndexPath];
  
  CGRect cellFrame = [cell convertRect:cell.bounds toView:toViewController.view];
  
//  CGRect cellFrame = [toViewController.tableView convertRect:[toViewController.tableView rectForRowAtIndexPath:[toViewController.tableView indexPathForSelectedRow]] toView:toViewController.view];

  UIView *fromSnapshot = [fromViewController.tableView snapshotViewAfterScreenUpdates:NO];
  fromViewController.view.hidden = YES;
  fromSnapshot.frame = [fromViewController.tableView convertRect:fromViewController.tableView.bounds toView:fromViewController.view];
  
  UIView *fromContentView = [[UIView alloc] initWithFrame:fromSnapshot.frame];
  fromSnapshot.frame = fromSnapshot.bounds;
  [fromContentView addSubview:fromSnapshot];
  fromContentView.clipsToBounds = YES;
  
  // Setup the initial view states
  [containerView addSubview:toViewController.view];
  [containerView addSubview:fromContentView];
  
  CGRect finalFrame = cellFrame;
  finalFrame.origin.y = CGRectGetMaxY(cellFrame);
  finalFrame.size.height = 0.0f;
  
  [UIView animateWithDuration:duration animations:^{
    
    fromContentView.frame = finalFrame;
    
  } completion:^(BOOL finished) {
    // Clean up
    fromViewController.view.hidden = NO;
    [fromContentView removeFromSuperview];
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.5;
  
}

@end
