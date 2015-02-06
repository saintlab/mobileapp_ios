//
//  OMNTransitionFromCalculatorToOrder.m
//  omnom
//
//  Created by tea on 22.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTransitionFromCalculatorToOrder.h"
#import "OMNCalculatorVC.h"
#import "OMNOrderCalculationVC.h"

@implementation OMNTransitionFromCalculatorToOrder

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNCalculatorVC *fromViewController = (OMNCalculatorVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNOrderCalculationVC *toViewController = (OMNOrderCalculationVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  if (fromViewController.productSelectionShown) {

    [containerView addSubview:toViewController.view];
    fromViewController.view.frame = [transitionContext initialFrameForViewController:fromViewController];
    [containerView addSubview:fromViewController.view];

    UITableView *fromSplitTableView = fromViewController.splitTableView;
    CGPoint fromSplitTableViewContentOffset = fromSplitTableView.contentOffset;
    CGRect frame = [fromSplitTableView convertRect:fromSplitTableView.bounds toView:containerView];
    fromSplitTableView.frame = frame;
    [containerView addSubview:fromSplitTableView];
    
    //reset scroll view offset
    fromSplitTableView.scrollEnabled = NO;
    fromSplitTableView.contentOffset = fromSplitTableViewContentOffset;

    UIView *toFooterView = toViewController.tableView.tableFooterView;
    CGRect toFooterViewFrame = [toFooterView convertRect:toFooterView.bounds toView:containerView];

    CGFloat fromTableContentViewBottom = CGRectGetMinY(fromSplitTableView.frame) - fromSplitTableView.contentOffset.y + MIN(fromSplitTableView.contentSize.height, CGRectGetHeight(fromSplitTableView.frame));
    
    CGFloat fromTableToDestimnationTableOffset = fromTableContentViewBottom - CGRectGetMinY(toFooterViewFrame);

    toViewController.tableView.transform = CGAffineTransformMakeTranslation(0.0f, fromTableToDestimnationTableOffset);
    
    [UIView animateWithDuration:duration animations:^{

      fromSplitTableView.transform = CGAffineTransformMakeTranslation(0.0f, -fromTableToDestimnationTableOffset);
      fromSplitTableView.alpha = 0.0f;
      fromViewController.view.alpha = 0.0f;
      toViewController.tableView.transform = CGAffineTransformIdentity;
      
    } completion:^(BOOL finished) {
      
      [fromSplitTableView removeFromSuperview];
      [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
      
    }];
    
  }
  else {
    
    UIView *fromSnapshotView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    fromSnapshotView.frame = [transitionContext initialFrameForViewController:fromViewController];
    fromViewController.view.hidden = YES;
    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromSnapshotView];
    [UIView animateWithDuration:duration animations:^{
      
      fromSnapshotView.alpha = 0.0f;
      
    } completion:^(BOOL finished) {
      
      [fromSnapshotView removeFromSuperview];
      fromViewController.view.hidden = NO;
      [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
      
    }];
    
  }
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.5;
  
}

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNCalculatorVC class] toClass:[OMNOrderCalculationVC class]]
           ];
}

@end
