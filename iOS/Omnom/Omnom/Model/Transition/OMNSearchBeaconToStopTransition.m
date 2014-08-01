//
//  OMNCustomFadeTransition.m
//  omnom
//
//  Created by tea on 25.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchBeaconToStopTransition.h"
#import "OMNBackgroundVC.h"
#import "OMNSearchBeaconVC.h"
#import "OMNAskNavigationPermissionsVC.h"
#import "OMNCircleRootVC.h"
#import "OMNR1VC.h"
#import "OMNTablePositionVC.h"

@implementation OMNSearchBeaconToStopTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNSearchBeaconVC *fromViewController = (OMNSearchBeaconVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNBackgroundVC *toViewController = (OMNBackgroundVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  // Get a snapshot of the image view
  UIView *fromImageSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
  fromImageSnapshot.frame = [transitionContext finalFrameForViewController:toViewController];

  UIView *fadeView = [[UIView alloc] initWithFrame:fromImageSnapshot.bounds];
  fadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  [fromImageSnapshot addSubview:fadeView];
  
  [toViewController.backgroundView addSubview:fromImageSnapshot];
  
  toViewController.view.alpha = 0.0f;
  
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:toViewController.view];
  
  [UIView animateWithDuration:duration animations:^{
    
    toViewController.view.alpha = 1.0f;
    
  } completion:^(BOOL finished) {
    
    fromViewController.view.hidden = NO;
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    
  }];
  
}

+ (NSArray *)keys {
  return
  @[
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNBackgroundVC class]],
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNAskNavigationPermissionsVC class]],
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNCircleRootVC class]],
    [self keyFromClass:[OMNSearchBeaconVC class] toClass:[OMNTablePositionVC class]],
    
    ];
}

@end
