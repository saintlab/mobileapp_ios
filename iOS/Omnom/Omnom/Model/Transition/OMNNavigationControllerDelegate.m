//
//  OMNNavigationControllerDelegate.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNavigationControllerDelegate.h"

#import "OMNTransitionFromListToProduct.h"
#import "OMNTransitionFromLoadingToBills.h"
#import "OMNTransitionFromOrdersToOrder.h"
#import "OMNTransitionFromOrderToOrders.h"
#import "OMNTransitionFromOrderToCalculator.h"
#import "OMNSearchRestaurantToSearchBeaconTransition.h"
#import "OMNSearchBeaconToStopTransition.h"
#import "OMNStopToSearchBeaconTransition.h"
#import "OMNSearchBeaconToRestaurantTransition.h"
#import "OMNRestaurantToSearchBeaconTransition.h"
#import "OMNSearchBeaconToPayOrderTransition.h"
#import "OMNOrderToRestaurantTransition.h"

@implementation OMNNavigationControllerDelegate {
  NSMutableDictionary *_transitions;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _transitions = [NSMutableDictionary dictionary];
    
    [self addTansitionForClass:[OMNTransitionFromLoadingToBills class]];
    [self addTansitionForClass:[OMNTransitionFromListToProduct class]];
    [self addTansitionForClass:[OMNTransitionFromOrdersToOrder class]];
    [self addTansitionForClass:[OMNTransitionFromOrderToCalculator class]];
    [self addTansitionForClass:[OMNTransitionFromOrderToOrders class]];
    [self addTansitionForClass:[OMNSearchRestaurantToSearchBeaconTransition class]];
    [self addTansitionForClass:[OMNSearchBeaconToStopTransition class]];
    [self addTansitionForClass:[OMNStopToSearchBeaconTransition class]];
    [self addTansitionForClass:[OMNSearchBeaconToRestaurantTransition class]];
    [self addTansitionForClass:[OMNRestaurantToSearchBeaconTransition class]];
    [self addTansitionForClass:[OMNSearchBeaconToPayOrderTransition class]];
    [self addTansitionForClass:[OMNOrderToRestaurantTransition class]];
    
  }
  return self;
}

- (void)addTansitionForClass:(Class)class {
  
  if (NO == [class isSubclassOfClass:[OMNCustomTransition class]]) {
    return;
  }
  
  [[class keys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
    _transitions[key] = NSStringFromClass(class);
  }];
  
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
  
  NSString *key = [OMNCustomTransition keyFromClass:[fromVC class] toClass:[toVC class]];
  NSString *transition = _transitions[key];
  
  if (transition) {
    return [[NSClassFromString(transition) alloc] init];
  }
  else {
    return nil;
  }
  
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
  return nil;
}

@end
