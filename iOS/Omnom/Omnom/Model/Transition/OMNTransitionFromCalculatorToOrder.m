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
  
 // OMNCalculatorVC *fromViewController = (OMNCalculatorVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNOrderCalculationVC *toViewController = (OMNOrderCalculationVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

  UIView *fromTableView = [toViewController.tableView snapshotViewAfterScreenUpdates:YES];
  
  UIView *containerView = [transitionContext containerView];
  [containerView addSubview:toViewController.view];
  [containerView addSubview:fromTableView];
  
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    
    fromTableView.alpha = 0.0f;
    
  } completion:^(BOOL finished) {
    
    // Declare that we've finished
    [fromTableView removeFromSuperview];
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 5.8;
}

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNCalculatorVC class] toClass:[OMNOrderCalculationVC class]]
           ];
}

@end
