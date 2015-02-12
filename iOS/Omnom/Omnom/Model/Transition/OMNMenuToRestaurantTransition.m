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
  
//  UIEdgeInsets initialContentInset = menuTable.contentInset;
//  CGRect fromTableFrame = menuTable.frame;
//  CGRect toTableFrame = [toViewController.tableView convertRect:toViewController.tableView.bounds toView:containerView];
//  
//  UIView *fadeView = [[UIView alloc] initWithFrame:fromViewController.view.bounds];
//  fadeView.backgroundColor = toViewController.fadeViewColor;
//  fadeView.alpha = 0.0f;
//  [fromViewController.view insertSubview:fadeView belowSubview:menuTable];
//  [fromViewController.view layoutIfNeeded];
//  //  [fromViewController.view bringSubviewToFront:menuTable];
//  
//  [UIView animateWithDuration:duration animations:^{
//    
//    fadeView.alpha = 1.0f;
//    fromViewController.circleButton.alpha = 0.0f;
//    menuTable.contentOffset = CGPointZero;
//    menuTable.contentInset = toViewController.tableView.contentInset;
//    menuTable.frame = toTableFrame;
//    
//  } completion:^(BOOL finished) {
//    
//    fromViewController.circleButton.alpha = 1.0f;
//    [fadeView removeFromSuperview];
//    menuTable.frame = fromTableFrame;
//    menuTable.bounces = YES;
//    menuTable.contentInset = initialContentInset;
//    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    
//  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  return 10.5;
  
}

@end
