//
//  GUserInfoTransition.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GUserInfoTransition.h"

static const CGFloat kLeftOffset = 50.0f;
static const CGFloat kSourceViewScale = 1;

static const NSTimeInterval kTransitionDuration = 0.25f;

@interface GUserInfoTransition ()

@property (nonatomic, assign) BOOL presenting;

@end

@implementation GUserInfoTransition {
}

+ (instancetype)forwardTransition {
  GUserInfoTransition *transition = [[[self class] alloc] init];
  transition.presenting = YES;
  return transition;
}

+ (instancetype)backwardTransition {
  return [[[self class] alloc] init];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return kTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  if (self.presenting) {
    
    [self animatePresentationTransition:transitionContext];
    
  } else {
    
    [self animateDismissalTransition:transitionContext];
    
  }
  
}

- (void)updateViewToInitialPosition:(UIView *)view containerView:(UIView *)containerView {
  
  [view setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
  view.transform = CGAffineTransformIdentity;
  view.center = CGPointMake(CGRectGetMidX(containerView.bounds),
                            CGRectGetMidY(containerView.bounds));
  
}

- (void)updateViewToFinalPosition:(UIView *)view containerView:(UIView *)containerView {
  
  [view setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
  view.transform = CGAffineTransformMakeScale(kSourceViewScale, kSourceViewScale);
  view.center = CGPointMake(kLeftOffset - CGRectGetWidth(containerView.bounds) / 2,
                            CGRectGetMidY(containerView.bounds));
  
}

- (void)animatePresentationTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  
  UIView *containerView = [transitionContext containerView];
  
  UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
  UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
  
  [containerView addSubview:toView];
  [containerView addSubview:fromView];
  
  NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
  
  [UIView animateWithDuration:animationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
    
    toView.frame = CGRectMake(kLeftOffset, 0, CGRectGetWidth(containerView.frame) - kLeftOffset, CGRectGetHeight(containerView.frame));
    [self updateViewToFinalPosition:fromView containerView:containerView];
    
  } completion:^(BOOL finished) {
    
    [transitionContext completeTransition:YES];
    
  }];
  
}

- (void)animateDismissalTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

  UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
  
  UIView *containerView = [transitionContext containerView];
  [self updateViewToFinalPosition:toView containerView:containerView];
  
  NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
  
  [UIView animateWithDuration:animationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut  animations:^{
    
    [self updateViewToInitialPosition:toView containerView:containerView];
    
  } completion:^(BOOL finished) {
    
    [transitionContext completeTransition:YES];
    
  }];
  
}

@end
