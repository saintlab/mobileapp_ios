//
//  OMNFadeTransition.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleFadeTransition.h"
#import "OMNSearchRestaurantsVC.h"
#import "OMNAskCLPermissionsVC.h"
#import "OMNDenyCLPermissionVC.h"
#import "OMNPushPermissionVC.h"
#import "OMNCLPermissionsHelpVC.h"
#import "OMNDemoRestaurantVC.h"
#import "OMNTransactionPaymentVC.h"
#import "OMNLogoVC.h"
#import "OMNRestaurantActionsVC.h"
#import "OMNRestaurantListVC.h"
#import "OMNRestaurantCardVC.h"
#import "OMNNoOrdersVC.h"
#import "OMNOrdersVC.h"
#import "OMNOrdersLoadingVC.h"
#import "OMNWishInfoVC.h"

@implementation OMNCircleFadeTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the image view
  UIView *fromImageSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
  fromImageSnapshot.frame = [transitionContext finalFrameForViewController:toViewController];
  
  fromViewController.view.hidden = YES;

  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [toViewController.view layoutIfNeeded];
  [containerView addSubview:toViewController.view];
  [containerView addSubview:fromImageSnapshot];
  
  [UIView animateWithDuration:duration animations:^{
    
    fromImageSnapshot.alpha = 0.0f;
    
  } completion:^(BOOL finished) {
    
    // Clean up
    [fromImageSnapshot removeFromSuperview];
    fromViewController.view.hidden = NO;
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
  
}

+ (NSArray *)keys {
  return
  @[
    
    [self keyFromClass:[OMNRestaurantListVC class] toClass:[OMNRestaurantCardVC class]],
    [self keyFromClass:[OMNRestaurantCardVC class] toClass:[OMNRestaurantListVC class]],
    
    [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNAskCLPermissionsVC class]],
    [self keyFromClass:[OMNAskCLPermissionsVC class] toClass:[OMNSearchRestaurantsVC class]],
    
    [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNCircleRootVC class]],
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNSearchRestaurantsVC class]],
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNCircleRootVC class]],
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNLoadingCircleVC class]],
    
    [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNPushPermissionVC class]],
    [self keyFromClass:[OMNRestaurantActionsVC class] toClass:[OMNPushPermissionVC class]],
    [self keyFromClass:[OMNLoadingCircleVC class] toClass:[OMNPushPermissionVC class]],
    [self keyFromClass:[OMNPushPermissionVC class] toClass:[OMNRestaurantActionsVC class]],
    
    [self keyFromClass:[OMNLoadingCircleVC class] toClass:[OMNRestaurantActionsVC class]],
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNRestaurantActionsVC class]],
    [self keyFromClass:[OMNDemoRestaurantVC class] toClass:[OMNRestaurantActionsVC class]],
    [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNRestaurantActionsVC class]],
    [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNRestaurantActionsVC class]],
    [self keyFromClass:[OMNRestaurantActionsVC class] toClass:[OMNSearchRestaurantsVC class]],
    [self keyFromClass:[OMNRestaurantActionsVC class] toClass:[OMNLoadingCircleVC class]],
    [self keyFromClass:[OMNRestaurantActionsVC class] toClass:[OMNOrdersLoadingVC class]],
    
    [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNDenyCLPermissionVC class]],
    [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNLogoVC class]],
    
    [self keyFromClass:[OMNDemoRestaurantVC class] toClass:[OMNSearchRestaurantsVC class]],
    [self keyFromClass:[OMNDemoRestaurantVC class] toClass:[OMNCircleRootVC class]],
    [self keyFromClass:[OMNRestaurantActionsVC class] toClass:[OMNCircleRootVC class]],

    [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNDemoRestaurantVC class]],
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNDemoRestaurantVC class]],
    [self keyFromClass:[OMNAskCLPermissionsVC class] toClass:[OMNDenyCLPermissionVC class]],
    [self keyFromClass:[OMNDenyCLPermissionVC class] toClass:[OMNAskCLPermissionsVC class]],
    [self keyFromClass:[OMNAskCLPermissionsVC class] toClass:[OMNCLPermissionsHelpVC class]],
    
    [self keyFromClass:[OMNTransactionPaymentVC class] toClass:[OMNLoadingCircleVC class]],
    [self keyFromClass:[OMNLoadingCircleVC class] toClass:[OMNTransactionPaymentVC class]],
    [self keyFromClass:[OMNLoadingCircleVC class] toClass:[OMNCircleRootVC class]],
    
    [self keyFromClass:[OMNLoadingCircleVC class] toClass:[OMNNoOrdersVC class]],
    [self keyFromClass:[OMNNoOrdersVC class] toClass:[OMNRestaurantActionsVC class]],
    
    [self keyFromClass:[OMNOrdersVC class] toClass:[OMNNoOrdersVC class]],
    [self keyFromClass:[OMNNoOrdersVC class] toClass:[OMNOrdersVC class]],

    [self keyFromClass:[OMNWishInfoVC class] toClass:[OMNCircleRootVC class]],
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNWishInfoVC class]],
    
    
    ];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.3;
  
}

@end
