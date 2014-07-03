//
//  OMNNavigationControllerDelegate.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNavigationControllerDelegate.h"
#import "OMNSearchTableVC.h"
#import "OMNOrdersVC.h"
#import "OMNRestaurantMenuVC.h"
#import "OMNProductDetailsVC.h"
#import "OMNPayOrderVC.h"
#import "OMNCalculatorVC.h"

#import "OMNTransitionFromListToProduct.h"
#import "OMNTransitionFromLoadingToBills.h"
#import "OMNTransitionFromOrdersToOrder.h"
#import "OMNTransitionFromOrderToOrders.h"
#import "OMNTransitionFromOrderToCalculator.h"

@implementation OMNNavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
  
  if ([fromVC isKindOfClass:[OMNSearchTableVC class]] &&
      [toVC isKindOfClass:[OMNOrdersVC class]]) {
    return [[OMNTransitionFromLoadingToBills alloc] init];
  }
  else if ([fromVC isKindOfClass:[OMNRestaurantMenuVC class]] &&
      [toVC isKindOfClass:[OMNProductDetailsVC class]]) {
    return [[OMNTransitionFromListToProduct alloc] init];
  }
  else if ([fromVC isKindOfClass:[OMNOrdersVC class]] &&
           [toVC isKindOfClass:[OMNPayOrderVC class]]) {
    return [[OMNTransitionFromOrdersToOrder alloc] init];
  }
  else if ([fromVC isKindOfClass:[OMNPayOrderVC class]] &&
           [toVC isKindOfClass:[OMNCalculatorVC class]]) {
    return [[OMNTransitionFromOrderToCalculator alloc] init];
  }
  else if ([fromVC isKindOfClass:[OMNPayOrderVC class]] &&
           [toVC isKindOfClass:[OMNOrdersVC class]]) {
    return [[OMNTransitionFromOrderToOrders alloc] init];
  }
  else {
    return nil;
  }

  
}

@end
