//
//  OMNSplashToLoaderTransition.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLogoVC.h"
#import <OMNStyler.h>
#import "OMNSplashToSearchBeaconTransition.h"
#import "OMNSearchRestaurantsVC.h"

@implementation OMNSplashToSearchBeaconTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNLogoVC *fromViewController = (OMNLogoVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNSearchRestaurantsVC *toViewController = (OMNSearchRestaurantsVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];

  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:toViewController.view];
  [toViewController.view layoutIfNeeded];
  
  UIImageView *fromViewSnapshot = [[UIImageView alloc] initWithImage:toViewController.backgroundView.image];
  fromViewSnapshot.contentMode = UIViewContentModeCenter;
  CAShapeLayer *layer = [CAShapeLayer layer];
  layer.fillColor = [UIColor colorWithPatternImage:fromViewController.bgIV.image].CGColor;
  CGFloat diametr = hypotf(containerView.frame.size.width, containerView.frame.size.height);
  CGFloat xOffset = (diametr - containerView.frame.size.width)/2.0f;
  CGFloat yOffset = (diametr - containerView.frame.size.height)/2.0f;
  layer.frame = containerView.bounds;
  layer.transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
  
  [fromViewSnapshot.layer addSublayer:layer];
  
  CGPoint circleCenter = toViewController.circleButton.center;

  UIImageView *iconsIV = [[UIImageView alloc] initWithImage:fromViewController.logoIconsIV.image];
  iconsIV.center = fromViewController.logoIconsIV.center;
  iconsIV.transform = fromViewController.logoIconsIV.transform;
  [fromViewSnapshot addSubview:iconsIV];
  
  CGFloat scale = 72.0f/162.0f;
  
  UIImageView *oldLogoIV = [[UIImageView alloc] initWithImage:fromViewController.logoIV.image];
  oldLogoIV.center = fromViewController.logoIV.center;
  [fromViewSnapshot addSubview:oldLogoIV];
  
  UIButton *newLogoIV = [[UIButton alloc] initWithFrame:toViewController.circleButton.frame];
  [newLogoIV setImage:toViewController.circleIcon forState:UIControlStateNormal];
  newLogoIV.transform =  CGAffineTransformMakeScale(scale, scale);
  newLogoIV.alpha = 0.0f;
  newLogoIV.center = fromViewController.logoIV.center;
  [fromViewSnapshot addSubview:newLogoIV];
  
  [containerView addSubview:fromViewSnapshot];
  fromViewController.view.hidden = YES;
  
  CGRect circleFrame = [toViewController.view.layer convertRect:toViewController.circleButton.frame toLayer:layer];
  UIBezierPath *fromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-xOffset, -yOffset, diametr, diametr)];
  UIBezierPath *toPath = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
  
  NSTimeInterval delay = 0.0;
  
  CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
  pathAnimation.duration = duration;
  pathAnimation.removedOnCompletion = NO;
  pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  pathAnimation.fromValue = (id)fromPath.CGPath;
  pathAnimation.toValue = (id)toPath.CGPath;
  layer.path = toPath.CGPath;
  layer.masksToBounds = YES;
  [layer addAnimation:pathAnimation forKey:@"path"];

  CAShapeLayer *colorLayer = [CAShapeLayer layer];
  colorLayer.frame = containerView.bounds;
  colorLayer.fillColor = [UIColor clearColor].CGColor;
  [layer addSublayer:colorLayer];
  
  CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
  colorAnimation.duration = duration;
  colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  colorAnimation.fromValue = (id)[UIColor clearColor].CGColor;
  UIColor *redColor = [OMNStyler redColor];
  colorAnimation.toValue = (id)redColor.CGColor;
  [colorLayer addAnimation:colorAnimation forKey:@"fillColor"];
  [colorLayer addAnimation:pathAnimation forKey:@"path"];
  colorLayer.fillColor = redColor.CGColor;
  colorLayer.path = toPath.CGPath;

  [UIView animateWithDuration:duration/2. delay:delay options:kNilOptions animations:^{
    
    iconsIV.alpha = 0.0f;
    oldLogoIV.alpha = 0.0f;
    
  } completion:^(BOOL finished) {
    
    [iconsIV removeFromSuperview];
    
  }];
  
  [UIView animateWithDuration:duration delay:delay options:kNilOptions animations:^{

    newLogoIV.center = circleCenter;
    newLogoIV.transform = CGAffineTransformIdentity;
    newLogoIV.alpha = 1.0f;
    
    oldLogoIV.center = circleCenter;
    oldLogoIV.transform = CGAffineTransformMakeScale(1.0f/scale, 1.0f/scale);;
    
  } completion:^(BOOL finished) {
    
    fromViewSnapshot.alpha = 0.0f;
    [fromViewSnapshot removeFromSuperview];
    fromViewController.view.hidden = NO;
    [layer removeFromSuperlayer];

    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {

  return [[OMNStyler styler] animationDurationForKey:@"SplashToSearchScreenTransitionDuration"];
  
}

+ (NSArray *)keys {
  return
  @[
    [self keyFromClass:[OMNLogoVC class] toClass:[OMNSearchRestaurantsVC class]],
    [self keyFromClass:[OMNLogoVC class] toClass:[OMNLoadingCircleVC class]]
    ];
}

@end
