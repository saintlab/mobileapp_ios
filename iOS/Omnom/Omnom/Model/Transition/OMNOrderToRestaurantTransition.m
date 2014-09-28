//
//  OMNOrderToRestaurantTransition.m
//  omnom
//
//  Created by tea on 28.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderToRestaurantTransition.h"
#import "OMNR1VC.h"
#import "OMNOrdersVC.h"
#import "OMNPayOrderVC.h"
#import <OMNStyler.h>
#import "OMNRatingVC.h"

@implementation OMNOrderToRestaurantTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNBackgroundVC *fromViewController = (OMNBackgroundVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNR1VC *toViewController = (OMNR1VC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  
  // Get a snapshot of the image view

  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:toViewController.view];

  UIImage *circleBackground = [toViewController.circleButton backgroundImageForState:UIControlStateNormal];
  [toViewController.view layoutIfNeeded];
  UIImageView *bigCircleIV = [[UIImageView alloc] initWithFrame:toViewController.circleButton.frame];
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
      
      bigCircleIV.transform = CGAffineTransformIdentity;
      
    } completion:^(BOOL finished) {
      
      [UIView animateWithDuration:OrderCircleFadeAnimationDuration animations:^{
        
        bigCircleIV.alpha = 0.0f;
        
      } completion:^(BOOL finished) {

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
    [self keyFromClass:[OMNRatingVC class] toClass:[OMNR1VC class]],
    [self keyFromClass:[OMNOrdersVC class] toClass:[OMNR1VC class]],
    [self keyFromClass:[OMNPayOrderVC class] toClass:[OMNR1VC class]],
    ];
}

@end
