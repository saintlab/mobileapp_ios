//
//  OMNSplashToLoaderTransition.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSplashToSearchBeaconTransition.h"
#import "OMNSearchRestaurantVC.h"
#import "OMNSearchBeaconVC.h"
#import "UIImage+omn_helper.h"

@implementation OMNSplashToSearchBeaconTransition {
  CAShapeLayer *_layer;
  CGRect _circleFrame;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNSearchRestaurantVC *fromViewController = (OMNSearchRestaurantVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNSearchBeaconVC *toViewController = (OMNSearchBeaconVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  [toViewController.view layoutIfNeeded];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];

  UIImage *toCircleBackground = [fromViewController.bgIV.image omn_ovalImageInRect:toViewController.circleButton.frame];
  toViewController.circleBackground = toCircleBackground;
  
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:toViewController.view];
  
  UIImageView *fromViewSnapshot = [[UIImageView alloc] initWithImage:toViewController.backgroundView.image];
  
  _layer = [CAShapeLayer layer];
  _layer.fillColor = [UIColor colorWithPatternImage:fromViewController.bgIV.image].CGColor;
  CGFloat diametr = hypotf(containerView.frame.size.width, containerView.frame.size.height);
  CGFloat xOffset = (diametr - containerView.frame.size.width)/2.0f;
  CGFloat yOffset = (diametr - containerView.frame.size.height)/2.0f;
  _layer.frame = containerView.bounds;
  _layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
  
  [fromViewSnapshot.layer addSublayer:_layer];
  
  CGPoint circleCenter = toViewController.circleButton.center;

  UIImageView *iconsIV = [[UIImageView alloc] initWithImage:fromViewController.logoIconsIV.image];
  iconsIV.center = fromViewController.logoIconsIV.center;
  iconsIV.transform = fromViewController.logoIconsIV.transform;
  [fromViewSnapshot addSubview:iconsIV];
  
  CGFloat scale = 72.0f/162.0f;
  
  UIImageView *oldLogoIV = [[UIImageView alloc] initWithImage:fromViewController.logoIV.image];
  oldLogoIV.center = fromViewController.logoIV.center;
  [fromViewSnapshot addSubview:oldLogoIV];
  
  UIImageView *newLogoIV = [[UIImageView alloc] initWithImage:toViewController.circleIcon];
  newLogoIV.transform =  CGAffineTransformMakeScale(scale, scale);
  newLogoIV.alpha = 0.0f;
  newLogoIV.center = fromViewController.logoIV.center;
  [fromViewSnapshot addSubview:newLogoIV];
  
  [containerView addSubview:fromViewSnapshot];
  fromViewController.view.hidden = YES;
  
  _circleFrame = [toViewController.view.layer convertRect:toViewController.circleButton.frame toLayer:_layer];
  UIBezierPath *fromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-xOffset, -yOffset, diametr, diametr)];
  UIBezierPath *toPath = [UIBezierPath bezierPathWithOvalInRect:_circleFrame];
  
  NSTimeInterval delay = 0.0;
  
  CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
  pathAnimation.duration = duration;
  pathAnimation.removedOnCompletion = NO;
  pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  pathAnimation.fromValue = (id)fromPath.CGPath;
  pathAnimation.toValue = (id)toPath.CGPath;
  _layer.path = toPath.CGPath;
  [_layer addAnimation:pathAnimation forKey:@"path"];

  [UIView animateWithDuration:duration/2. delay:delay options:0 animations:^{
    iconsIV.alpha = 0.0f;
    oldLogoIV.alpha = 0.0f;
  } completion:^(BOOL finished) {
    [iconsIV removeFromSuperview];
  }];
  
  [UIView animateWithDuration:duration delay:delay options:0 animations:^{

    newLogoIV.center = circleCenter;
    newLogoIV.transform = CGAffineTransformIdentity;
    newLogoIV.alpha = 1.0f;
    
    oldLogoIV.center = circleCenter;
    oldLogoIV.transform = CGAffineTransformMakeScale(1.0f/scale, 1.0f/scale);;
    
  } completion:^(BOOL finished) {
    fromViewSnapshot.alpha = 0.0f;
    [fromViewSnapshot removeFromSuperview];
    fromViewController.view.hidden = NO;
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    
  }];
  
}

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNSearchRestaurantVC class] toClass:[OMNSearchBeaconVC class]],
           [self keyFromClass:[OMNSearchRestaurantVC class] toClass:[OMNLoadingCircleVC class]]
           ];
}

@end