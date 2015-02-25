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
#import "OMNMenuItemCell.h"
#import "OMNMenuHeaderLabel.h"

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
  OMNMenuItemCell *menuItemCell = (OMNMenuItemCell *)[fromViewController.tableView cellForRowAtIndexPath:[fromViewController.tableView indexPathForSelectedRow]];

  
  CGRect cellFrame = [fromViewController.tableView convertRect:[fromViewController.tableView rectForRowAtIndexPath:[fromViewController.tableView indexPathForSelectedRow]] toView:fromViewController.view];
  

  OMNMenuHeaderLabel *headerLabel = [[OMNMenuHeaderLabel alloc] init];
  headerLabel.text = menuItemCell.label.text;
  [headerLabel sizeToFit];
  headerLabel.center = CGPointMake(CGRectGetMidX(cellFrame), CGRectGetMidY(cellFrame));
  menuItemCell.label.hidden = YES;
  
  // Setup the initial view states
  CGRect toViewControllerFrame = CGRectMake(cellFrame.origin.x, CGRectGetMinY(cellFrame), CGRectGetWidth(cellFrame), CGRectGetHeight(cellFrame));
  toViewController.view.clipsToBounds = YES;
  toViewController.view.frame = toViewControllerFrame;
  toViewController.backgroundView.alpha = 0.0f;
  toViewController.view.backgroundColor = [UIColor clearColor];
  [containerView addSubview:toViewController.view];
  [containerView addSubview:headerLabel];
  
  toViewController.headerLabel.hidden = YES;
  
  [UIView animateWithDuration:duration animations:^{

    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    UIView *navBar = toViewController.navigationController.navigationBar;
    headerLabel.center = [navBar convertPoint:CGPointMake(CGRectGetWidth(navBar.frame)/2.0f, CGRectGetHeight(navBar.frame)/2.0f) toView:nil];
    
  } completion:^(BOOL finished) {
    // Clean up
    toViewController.headerLabel.hidden = NO;
    menuItemCell.label.hidden = NO;
    [headerLabel removeFromSuperview];
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
