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

@implementation OMNOrderToRestaurantTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNR1VC *toViewController = (OMNR1VC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  
  // Get a snapshot of the image view
  UIView *fromImageSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
  fromViewController.view.hidden = YES;

  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  
  [containerView addSubview:toViewController.view];
  
  UIImage *circleBackground = [toViewController.circleButton backgroundImageForState:UIControlStateNormal];
  [toViewController.view layoutIfNeeded];
  UIImageView *bigCircleIV = [[UIImageView alloc] initWithFrame:toViewController.circleButton.frame];
  bigCircleIV.image = circleBackground;
  [containerView addSubview:bigCircleIV];
  
  [containerView addSubview:fromImageSnapshot];
  
  CGFloat scale = 5.0f;
  bigCircleIV.transform = CGAffineTransformMakeScale(scale, scale);
  
  NSTimeInterval OrderSlideAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderSlideAnimationDuration"];
  NSTimeInterval OrderCircleChangeSizeAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderCircleChangeSizeAnimationDuration"];
  NSTimeInterval OrderCircleFadeAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"OrderCircleFadeAnimationDuration"];
  
  [UIView animateWithDuration:OrderSlideAnimationDuration animations:^{
    
    fromImageSnapshot.transform = CGAffineTransformMakeTranslation(0.0f, -2*CGRectGetHeight(fromImageSnapshot.frame));
    
  } completion:^(BOOL finished) {

    [fromImageSnapshot removeFromSuperview];
    [UIView animateWithDuration:OrderCircleChangeSizeAnimationDuration animations:^{
      
      bigCircleIV.transform = CGAffineTransformIdentity;
      
    } completion:^(BOOL finished) {
      
      [UIView animateWithDuration:OrderCircleFadeAnimationDuration animations:^{
        
        bigCircleIV.alpha = 0.0f;
        
      } completion:^(BOOL finished) {

        fromViewController.view.hidden = NO;
        [bigCircleIV removeFromSuperview];
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
    [self keyFromClass:[OMNOrdersVC class] toClass:[OMNR1VC class]],
    [self keyFromClass:[OMNPayOrderVC class] toClass:[OMNR1VC class]],
    ];
}

@end
