//
//  OMNFadeTransition.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleFadeTransition.h"
#import "OMNSearchBeaconVC.h"
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
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNAskCLPermissionsVC class]],
    [self keyFromClass:[OMNAskCLPermissionsVC class] toClass:[OMNSearchBeaconVC class]],
    
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNCircleRootVC class]],
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNSearchBeaconVC class]],
    
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNTablePositionVC class]],
    [self keyFromClass:[OMNTablePositionVC class] toClass:[OMNSearchBeaconVC class]],
    
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNPushPermissionVC class]],
    
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNTurnOnBluetoothVC class]],
    [self keyFromClass:[OMNTurnOnBluetoothVC class] toClass:[OMNSearchBeaconVC class]],
    
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNR1VC class]],
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNDenyCLPermissionVC class]],
    
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNR1VC class]],
    [self keyFromClass:[OMNDemoRestaurantVC class] toClass:[OMNR1VC class]],
    [self keyFromClass:[OMNDemoRestaurantVC class] toClass:[OMNSearchBeaconVC class]],
    [self keyFromClass:[OMNDemoRestaurantVC class] toClass:[OMNCircleRootVC class]],

    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNDemoRestaurantVC class]],
    [self keyFromClass:[OMNCircleRootVC class] toClass:[OMNDemoRestaurantVC class]],
    [self keyFromClass:[OMNAskCLPermissionsVC class] toClass:[OMNDenyCLPermissionVC class]],
    [self keyFromClass:[OMNDenyCLPermissionVC class] toClass:[OMNAskCLPermissionsVC class]],
    [self keyFromClass:[OMNAskCLPermissionsVC class] toClass:[OMNCLPermissionsHelpVC class]],
    
    [self keyFromClass:[OMNMailRUPayVC class] toClass:[OMNLoadingCircleVC class]],
    [self keyFromClass:[OMNLoadingCircleVC class] toClass:[OMNMailRUPayVC class]],
    ];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

@end
