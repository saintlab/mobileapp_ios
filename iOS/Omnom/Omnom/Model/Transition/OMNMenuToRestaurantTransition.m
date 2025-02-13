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
  
  UITableView *fromMenuTable = fromViewController.tableView;
  
  [containerView addSubview:toViewController.view];
  [containerView addSubview:fromViewController.view];
  
  CGRect toTableFrame = [toViewController.menuTable convertRect:toViewController.menuTable.bounds toView:containerView];
  toViewController.menuTable.hidden = YES;
  toTableFrame.size = fromViewController.tableView.frame.size;
  fromViewController.navigationFadeView.alpha = 0.0f;
  
  [fromViewController closeAllCategoriesWithCompletion:^{
  }];

  fromMenuTable.bounces = NO;
  
  [UIView animateWithDuration:duration animations:^{
    
    fromViewController.backgroundView.alpha = 0.0f;
    fromMenuTable.frame = toTableFrame;
    fromMenuTable.contentInset = toViewController.menuTable.contentInset;
    
  } completion:^(BOOL finished1) {
    
    toViewController.menuTable.hidden = NO;
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    
  }];

}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return kCloseAllCategoriesDuration + 0.2;
}

@end
