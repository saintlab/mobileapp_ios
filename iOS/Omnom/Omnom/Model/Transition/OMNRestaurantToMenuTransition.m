//
//  OMNRestaurantToMenuTransition.m
//  omnom
//
//  Created by tea on 12.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantToMenuTransition.h"
#import "OMNR1VC.h"
#import "OMNMenuVC.h"

@implementation OMNRestaurantToMenuTransition

+ (NSArray *)keys {
  return @[[self keyFromClass:[OMNR1VC class] toClass:[OMNMenuVC class]]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNR1VC *fromViewController = (OMNR1VC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNMenuVC *toViewController = (OMNMenuVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  UITableView *menuTable = fromViewController.menuTable;
  menuTable.bounces = NO;
  
  
  [containerView addSubview:toViewController.view];
  [containerView addSubview:fromViewController.view];

  UIEdgeInsets initialContentInset = menuTable.contentInset;
  CGRect fromTableFrame = menuTable.frame;
  CGRect toTableFrame = [toViewController.tableView convertRect:toViewController.tableView.bounds toView:containerView];
  
  UIView *fadeView = [[UIView alloc] initWithFrame:fromViewController.view.bounds];
  fadeView.backgroundColor = toViewController.fadeViewColor;
  fadeView.alpha = 0.0f;
  [fromViewController.view insertSubview:fadeView belowSubview:menuTable];
  [fromViewController.view layoutIfNeeded];
//  [fromViewController.view bringSubviewToFront:menuTable];

  [UIView animateWithDuration:duration animations:^{
    
    fadeView.alpha = 1.0f;
    fromViewController.circleButton.alpha = 0.0f;
    menuTable.contentOffset = CGPointZero;
    menuTable.contentInset = toViewController.tableView.contentInset;
    menuTable.frame = toTableFrame;
    
  } completion:^(BOOL finished) {
    
    fromViewController.circleButton.alpha = 1.0f;
    [fadeView removeFromSuperview];
    menuTable.frame = fromTableFrame;
    menuTable.bounces = YES;
    menuTable.contentInset = initialContentInset;
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    
  }];

}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.5;
  
}

@end
