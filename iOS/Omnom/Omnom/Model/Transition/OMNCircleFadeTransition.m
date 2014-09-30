//
//  OMNFadeTransition.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleFadeTransition.h"
#import "OMNSearchVisitorVC.h"
#import "OMNCircleRootVC.h"
#import "OMNTablePositionVC.h"
#import "OMNR1VC.h"
#import "OMNStartVC.h"
#import "OMNAskCLPermissionsVC.h"
#import "OMNDenyCLPermissionVC.h"
#import "OMNPushPermissionVC.h"
#import "OMNTurnOnBluetoothVC.h"
#import "OMNCLPermissionsHelpVC.h"
#import "OMNDemoRestaurantVC.h"
#import "OMNMailRUPayVC.h"
#import "OMNSearchRestaurantVC.h"

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
    [self keyFromClass:[OMNSearchVisitorVC class] toClass:[OMNAskCLPermissionsVC class]],
    [self keyFromClass:[OMNAskCLPermissionsVC class] toClass:[OMNSearchVisitorVC class]],
    
    [self keyFromClass:[OMNSearchVisitorVC class] toClass:[OMNCircleRootVC class]],
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNSearchVisitorVC class]],
    
    [self keyFromClass:[OMNSearchVisitorVC class] toClass:[OMNTablePositionVC class]],
    [self keyFromClass:[OMNTablePositionVC class] toClass:[OMNSearchVisitorVC class]],
    
    [self keyFromClass:[OMNSearchVisitorVC class] toClass:[OMNPushPermissionVC class]],
    [self keyFromClass:[OMNR1VC class] toClass:[OMNPushPermissionVC class]],

    [self keyFromClass:[OMNSearchVisitorVC class] toClass:[OMNTurnOnBluetoothVC class]],
    [self keyFromClass:[OMNTurnOnBluetoothVC class] toClass:[OMNSearchVisitorVC class]],
    
    [self keyFromClass:[OMNSearchVisitorVC class] toClass:[OMNR1VC class]],
    [self keyFromClass:[OMNSearchVisitorVC class] toClass:[OMNDenyCLPermissionVC class]],
    [self keyFromClass:[OMNSearchVisitorVC class] toClass:[OMNSearchRestaurantVC class]],
    
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNR1VC class]],
    [self keyFromClass:[OMNDemoRestaurantVC class] toClass:[OMNR1VC class]],
    [self keyFromClass:[OMNDemoRestaurantVC class] toClass:[OMNSearchVisitorVC class]],
    [self keyFromClass:[OMNDemoRestaurantVC class] toClass:[OMNCircleRootVC class]],
    [self keyFromClass:[OMNR1VC class] toClass:[OMNCircleRootVC class]],

    [self keyFromClass:[OMNSearchVisitorVC class] toClass:[OMNDemoRestaurantVC class]],
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNDemoRestaurantVC class]],
    [self keyFromClass:[OMNAskCLPermissionsVC class] toClass:[OMNDenyCLPermissionVC class]],
    [self keyFromClass:[OMNDenyCLPermissionVC class] toClass:[OMNAskCLPermissionsVC class]],
    [self keyFromClass:[OMNAskCLPermissionsVC class] toClass:[OMNCLPermissionsHelpVC class]],
    
    [self keyFromClass:[OMNMailRUPayVC class] toClass:[OMNLoadingCircleVC class]],
    [self keyFromClass:[OMNLoadingCircleVC class] toClass:[OMNMailRUPayVC class]],
    [self keyFromClass:[OMNLoadingCircleVC class] toClass:[OMNR1VC class]],
    
    
    ];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

@end
