//
//  OMNMenuToRestaurantTransition.m
//  omnom
//
//  Created by tea on 12.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuToRestaurantTransition.h"
#import "OMNR1VC.h"
#import "OMNMenuVC.h"

@implementation OMNMenuToRestaurantTransition

+ (NSArray *)keys {
  return @[[self keyFromClass:[OMNMenuVC class] toClass:[OMNR1VC class]]];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNMenuVC *fromViewController = (OMNMenuVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNR1VC *toViewController = (OMNR1VC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  UITableView *menuTable = fromViewController.tableView;
  menuTable.bounces = NO;
  
  [containerView addSubview:toViewController.view];
  [containerView addSubview:fromViewController.view];
  
  CGRect toTableFrame = [toViewController.menuTable convertRect:toViewController.menuTable.bounds toView:containerView];
  toViewController.menuTable.alpha = 0.0f;
  toTableFrame.size = fromViewController.tableView.frame.size;
  
  [UIView animateWithDuration:duration animations:^{
    
    fromViewController.backgroundView.alpha = 0.0f;
    fromViewController.navigationFadeView.alpha = 0.0f;
    menuTable.frame = toTableFrame;
    
  } completion:^(BOOL finished) {
  
    [UIView animateWithDuration:0.5 animations:^{
      
      toViewController.menuTable.alpha = 1.0f;
      
    } completion:^(BOOL finished) {
      
      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

    }];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.5;
  
}

@end
