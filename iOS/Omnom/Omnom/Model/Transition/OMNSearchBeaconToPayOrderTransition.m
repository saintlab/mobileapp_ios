//
//  OMNSearchBeaconToPayOrderTransition.m
//  omnom
//
//  Created by tea on 26.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchBeaconToPayOrderTransition.h"
#import "OMNSearchRestaurantsVC.h"
#import "OMNOrderCalculationVC.h"
#import "OMNOrdersVC.h"
#import <OMNStyler.h>
#import "OMNPushPermissionVC.h"
#import "OMNRestaurantActionsVC.h"
#import "OMNOrdersLoadingVC.h"

@implementation OMNSearchBeaconToPayOrderTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNBackgroundVC *toViewController = (OMNBackgroundVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];

  // Get a snapshot of the image view
  UIView *fromImageSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
  fromViewController.view.hidden = YES;
  
  // Setup the initial view states
  [containerView addSubview:fromImageSnapshot];
  
  
  
  OMNCircleRootVC *circleRootVC = nil;

  if ([fromViewController isKindOfClass:[OMNCircleRootVC class]]) {
    
    circleRootVC = (OMNCircleRootVC *)fromViewController;
    
  }
  else if ([fromViewController isKindOfClass:[OMNRestaurantActionsVC class]]) {
    
    OMNRestaurantActionsVC *restaurantActionsVC = (OMNRestaurantActionsVC *)fromViewController;
    circleRootVC = restaurantActionsVC.r1VC;
    
    if (NO == restaurantActionsVC.r1VC.isViewVisible) {

//      CGFloat scale = 0.1f;
//      initialCircleTransofrm = CGAffineTransformMakeScale(scale, scale);

    }
    
  }
  
  UIImage *circleBackground = circleRootVC.circleBackground;
  UIImageView *bigCircleIV = [[UIImageView alloc] init];
  bigCircleIV.frame = circleRootVC.circleButton.frame;
  bigCircleIV.image = circleBackground;
  [containerView addSubview:bigCircleIV];

  UIImageView *toBackgroundView = [[UIImageView alloc] initWithFrame:toViewController.view.frame];
  
  toBackgroundView.contentMode = UIViewContentModeCenter;
  toBackgroundView.image = toViewController.backgroundImage;
  toBackgroundView.alpha = 0.0f;
  [containerView addSubview:toBackgroundView];
  
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:toViewController.view];
  toViewController.backgroundView.alpha = 0.0f;
  toViewController.view.transform = CGAffineTransformMakeTranslation(0.0f, -2*CGRectGetHeight(toViewController.view.frame));

  NSTimeInterval OrderSlideAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderSlideAnimationDuration"];
  NSTimeInterval OrderCircleChangeSizeAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderCircleChangeSizeAnimationDuration"];
  
  CGFloat scale = 5.0f;
  
  [UIView animateWithDuration:OrderCircleChangeSizeAnimationDuration animations:^{
    
    bigCircleIV.transform = CGAffineTransformMakeScale(scale, scale);
    
  } completion:^(BOOL finished) {
    
    [fromImageSnapshot removeFromSuperview];
    [UIView animateWithDuration:OrderSlideAnimationDuration animations:^{
      
      toBackgroundView.alpha = 1.0f;
      toViewController.view.transform = CGAffineTransformIdentity;
      
    } completion:^(BOOL finished) {
      
      toViewController.backgroundView.alpha = 1.0f;
      [bigCircleIV removeFromSuperview];
      [toBackgroundView removeFromSuperview];
      fromViewController.view.hidden = NO;
      [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
      
    }];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  NSTimeInterval OrderSlideAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderSlideAnimationDuration"];
  NSTimeInterval OrderCircleChangeSizeAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderCircleChangeSizeAnimationDuration"];
  return OrderSlideAnimationDuration + OrderCircleChangeSizeAnimationDuration;
}

+ (NSArray *)keys {
  return
  @[
    [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNOrderCalculationVC class]],
    [self keyFromClass:[OMNSearchRestaurantsVC class] toClass:[OMNOrdersVC class]],
    [self keyFromClass:[OMNPushPermissionVC class] toClass:[OMNOrderCalculationVC class]],
    [self keyFromClass:[OMNPushPermissionVC class] toClass:[OMNOrdersVC class]],
    [self keyFromClass:[OMNRestaurantActionsVC class] toClass:[OMNOrdersVC class]],
    [self keyFromClass:[OMNRestaurantActionsVC class] toClass:[OMNOrderCalculationVC class]],
    [self keyFromClass:[OMNOrdersLoadingVC class] toClass:[OMNOrderCalculationVC class]],
    [self keyFromClass:[OMNOrdersLoadingVC class] toClass:[OMNOrdersVC class]],
    ];
}

@end
