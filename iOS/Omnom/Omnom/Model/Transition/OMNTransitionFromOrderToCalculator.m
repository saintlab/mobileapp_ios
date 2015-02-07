//
//  OMNCalculatorTransition.m
//  restaurants
//
//  Created by tea on 23.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTransitionFromOrderToCalculator.h"
#import "OMNCalculatorVC.h"
#import "OMNOrderCalculationVC.h"
#import "UITableView+screenshot.h"
#import "UIView+screenshot.h"

@implementation OMNTransitionFromOrderToCalculator 

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNOrderCalculationVC *fromViewController = (OMNOrderCalculationVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNCalculatorVC *toViewController = (OMNCalculatorVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];

  UITableView *fromTableView = fromViewController.tableView;
  CGRect initialTableFrame = fromTableView.frame;
  UIView *tableSuperView = fromTableView.superview;
  CGRect startTableRect = [fromTableView convertRect:fromTableView.bounds toView:nil];
  CGPoint startTableOffset = fromTableView.contentOffset;
  
  [containerView addSubview:fromViewController.view];
  [containerView addSubview:fromTableView];
  [containerView addSubview:toViewController.view];
  fromTableView.frame = startTableRect;
  toViewController.view.alpha = 0.0f;
  toViewController.view.backgroundColor = [UIColor clearColor];
  toViewController.containerView.alpha = 0.0f;
  
  UIView *footerSnapshot = [fromTableView.tableFooterView snapshotViewAfterScreenUpdates:NO];
  footerSnapshot.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  UIView *footerExtendedView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(footerSnapshot.frame), 0.0f)];
  footerExtendedView.backgroundColor = [UIColor whiteColor];
  [footerExtendedView addSubview:footerSnapshot];
  
  [fromTableView.tableFooterView addSubview:footerExtendedView];
  
  CGRect footerEndFrame = footerExtendedView.frame;
  footerEndFrame.size.height = CGRectGetHeight(containerView.frame);
  CGRect endTableRect = [toViewController.splitTableView convertRect:toViewController.splitTableView.bounds toView:containerView];
  endTableRect.size.height = fromTableView.contentSize.height - CGRectGetHeight(fromTableView.tableHeaderView.frame);
  
  CGPoint offset = CGPointMake(0.0f, CGRectGetHeight(fromViewController.tableView.tableHeaderView.frame));
  
  NSTimeInterval fadeDuration = 0.3;
  
  [UIView animateWithDuration:(duration-fadeDuration) delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    
    fromTableView.frame = endTableRect;
    fromTableView.contentOffset = offset;
    footerExtendedView.frame = footerEndFrame;
    toViewController.view.alpha = 1.0f;
    
  } completion:^(BOOL finished) {
    
    [UIView animateWithDuration:fadeDuration animations:^{
      
      toViewController.containerView.alpha = 1.0f;
      
    } completion:^(BOOL finished) {
      
      [tableSuperView addSubview:fromTableView];
      fromTableView.frame = initialTableFrame;
      fromTableView.contentOffset = startTableOffset;
      fromViewController.view.hidden = NO;
      [footerExtendedView removeFromSuperview];
      toViewController.view.backgroundColor = [UIColor whiteColor];

      [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
      
    }];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.9;
  
}

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNOrderCalculationVC class] toClass:[OMNCalculatorVC class]]
           ];
}

@end
