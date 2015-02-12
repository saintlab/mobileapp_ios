//
//  OMNNavigationControllerDelegate.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNavigationControllerDelegate.h"

#import "OMNTransitionFromListToProduct.h"
#import "OMNTransitionFromOrdersToOrder.h"
#import "OMNTransitionFromOrderToOrders.h"
#import "OMNTransitionFromOrderToCalculator.h"
#import "OMNSplashToSearchBeaconTransition.h"
#import "OMNRestaurantToSearchBeaconTransition.h"
#import "OMNSearchBeaconToPayOrderTransition.h"
#import "OMNOrderToRestaurantTransition.h"
#import "OMNCircleFadeTransition.h"
#import "UINavigationController+omn_replace.h"
#import "OMNSlideUpTransition.h"
#import "OMNSlideDownTransition.h"
#import "OMNTransitionFromProductToList.h"
#import "OMNTransitionFromCalculatorToOrder.h"
#import "OMNInteractiveTransitioningProtocol.h"
#import "OMNPushUpTransition.h"
#import "OMNMenuToCategoryTransition.h"
#import "OMNCategoryToMenuTransition.h"

@implementation OMNNavigationControllerDelegate {
  
  NSMutableDictionary *_transitions;
  
}

+ (instancetype)sharedDelegate {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _transitions = [NSMutableDictionary dictionary];
    
    [self addTansitionForClass:[OMNTransitionFromProductToList class]];
    [self addTansitionForClass:[OMNCircleFadeTransition class]];
    [self addTansitionForClass:[OMNTransitionFromListToProduct class]];
    [self addTansitionForClass:[OMNTransitionFromOrdersToOrder class]];
    [self addTansitionForClass:[OMNTransitionFromOrderToCalculator class]];
    [self addTansitionForClass:[OMNTransitionFromOrderToOrders class]];
    [self addTansitionForClass:[OMNRestaurantToSearchBeaconTransition class]];
    [self addTansitionForClass:[OMNSearchBeaconToPayOrderTransition class]];
    [self addTansitionForClass:[OMNOrderToRestaurantTransition class]];
    [self addTansitionForClass:[OMNOrderToRestaurantTransition class]];
    [self addTansitionForClass:[OMNSlideUpTransition class]];
    [self addTansitionForClass:[OMNSlideDownTransition class]];
    [self addTansitionForClass:[OMNSplashToSearchBeaconTransition class]];
    [self addTansitionForClass:[OMNPushUpTransition class]];
    [self addTansitionForClass:[OMNMenuToCategoryTransition class]];
    [self addTansitionForClass:[OMNCategoryToMenuTransition class]];
    [self addTansitionForClass:[OMNTransitionFromCalculatorToOrder class]];
    
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
  
  if (transition &&
      fromVC &&
      toVC) {

    OMNCustomTransition *customTransition = [[NSClassFromString(transition) alloc] init];
    customTransition.sourceController = fromVC;
    return customTransition;
    
  }
  else {
    return nil;
  }
  
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  
  if ([navigationController respondsToSelector:@selector(omn_didShowViewController:)]) {
    [navigationController omn_didShowViewController:viewController];
  }
  
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {

  if ([animationController isKindOfClass:[OMNCustomTransition class]]) {
    id backgroundVC = [(OMNCustomTransition *)animationController sourceController];
    if ([backgroundVC conformsToProtocol:@protocol(OMNInteractiveTransitioningProtocol)]) {
      return [backgroundVC interactiveTransitioning];
    }
    
  }
  
  return nil;
}

@end
