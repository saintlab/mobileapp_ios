//
//  OMNOrderToRestaurantTransition.m
//  omnom
//
//  Created by tea on 28.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderToRestaurantTransition.h"
#import "OMNRestaurantActionsVC.h"
#import "OMNOrdersVC.h"
#import "OMNOrderCalculationVC.h"
#import <OMNStyler.h>
#import "OMNRatingVC.h"

@implementation OMNOrderToRestaurantTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNBackgroundVC *fromViewController = (OMNBackgroundVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNRestaurantActionsVC *toViewController = (OMNRestaurantActionsVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  
  // Get a snapshot of the image view

  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:toViewController.view];

  UIImage *circleBackground = [toViewController.r1VC.circleButton backgroundImageForState:UIControlStateNormal];
  [toViewController.view layoutIfNeeded];
  UIImageView *bigCircleIV = [[UIImageView alloc] initWithFrame:toViewController.r1VC.circleButton.frame];
  bigCircleIV.image = circleBackground;
  [containerView addSubview:bigCircleIV];

  UIImageView *toBackgroundView = [[UIImageView alloc] initWithFrame:fromViewController.view.frame];
  toBackgroundView.contentMode = UIViewContentModeCenter;
  toBackgroundView.image = fromViewController.backgroundImage;
  [containerView addSubview:toBackgroundView];
  
  fromViewController.backgroundView.hidden = YES;
  [containerView addSubview:fromViewController.view];
  
  CGFloat scale = 5.0f;
  bigCircleIV.transform = CGAffineTransformMakeScale(scale, scale);
  
  NSTimeInterval OrderSlideAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderSlideAnimationDuration"];
  NSTimeInterval OrderCircleChangeSizeAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderCircleChangeSizeAnimationDuration"];
  NSTimeInterval OrderCircleFadeAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderCircleFadeAnimationDuration"];
  
  [UIView animateWithDuration:OrderSlideAnimationDuration animations:^{
    
    fromViewController.view.transform = CGAffineTransformMakeTranslation(0.0f, -2*CGRectGetHeight(fromViewController.view.frame));
    toBackgroundView.alpha = 0.0f;
    
  } completion:^(BOOL finished) {

    [toBackgroundView removeFromSuperview];
    fromViewController.backgroundView.hidden = NO;
    
    [UIView animateWithDuration:OrderCircleChangeSizeAnimationDuration animations:^{
      
      if (toViewController.r1VC.isViewVisible) {
        bigCircleIV.transform = CGAffineTransformIdentity;
      }
      else {
        bigCircleIV.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
      }
      
    } completion:^(BOOL finished1) {
      
      [UIView animateWithDuration:OrderCircleFadeAnimationDuration animations:^{
        
        bigCircleIV.alpha = 0.0f;
        
      } completion:^(BOOL finished2) {

        fromViewController.backgroundView.alpha = 1.0f;
        fromViewController.view.hidden = NO;
        [bigCircleIV removeFromSuperview];
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
      }];
      
      
    }];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  NSTimeInterval OrderSlideAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderSlideAnimationDuration"];
  NSTimeInterval OrderCircleChangeSizeAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderCircleChangeSizeAnimationDuration"];
  NSTimeInterval OrderCircleFadeAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderCircleFadeAnimationDuration"];
  return OrderSlideAnimationDuration + OrderCircleChangeSizeAnimationDuration + OrderCircleFadeAnimationDuration;
}

+ (NSArray *)keys {
  return
  @[
    [self keyFromClass:[OMNRatingVC class] toClass:[OMNRestaurantActionsVC class]],
    [self keyFromClass:[OMNOrdersVC class] toClass:[OMNRestaurantActionsVC class]],
    [self keyFromClass:[OMNOrderCalculationVC class] toClass:[OMNRestaurantActionsVC class]],
    ];
}

@end
