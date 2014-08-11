//
//  GUserInfoTransition.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoTransition.h"

@interface OMNTapView : UIButton

@property (nonatomic, copy) dispatch_block_t didTapBlock;

@end

static const CGFloat kLeftOffset = 50.0f;

static const NSTimeInterval kTransitionDuration = 0.2f;

@interface OMNUserInfoTransition ()

@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, copy) dispatch_block_t completionBlock;

@end

@implementation OMNUserInfoTransition {
}

+ (instancetype)forwardTransitionWithCompletion:(dispatch_block_t)completionBlock {
  OMNUserInfoTransition *transition = [[[self class] alloc] init];
  transition.completionBlock = completionBlock;
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
  
  view.transform = CGAffineTransformIdentity;
  
}

- (void)updateViewToFinalPosition:(UIView *)view containerView:(UIView *)containerView {
  
  view.transform = CGAffineTransformMakeTranslation(kLeftOffset - CGRectGetWidth(containerView.bounds), 0);
  
}

- (void)animatePresentationTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  
  UIView *containerView = [transitionContext containerView];
  
  UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
  UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
  
  UIView *fromSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
  fromSnapshot.frame = fromView.frame;
  [containerView insertSubview:fromSnapshot aboveSubview:fromView];
  [fromView removeFromSuperview];
  
  [containerView insertSubview:toView belowSubview:fromSnapshot];
  
  NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
  
  toView.frame = CGRectMake(kLeftOffset, 0, CGRectGetWidth(containerView.frame) - kLeftOffset, CGRectGetHeight(containerView.frame));
  
  OMNTapView *tapView = [[OMNTapView alloc] initWithFrame:CGRectMake(0, 0, kLeftOffset, CGRectGetHeight(containerView.frame))];
  tapView.didTapBlock = self.completionBlock;
  [containerView addSubview:tapView];
  
  [UIView animateWithDuration:animationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
    
    [self updateViewToFinalPosition:fromSnapshot containerView:containerView];
    
  } completion:^(BOOL finished) {
    
    [transitionContext completeTransition:YES];
    
  }];
  
}

- (void)animateDismissalTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

  UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
  UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
  UIView *fromSnapshot = [fromView snapshotViewAfterScreenUpdates:YES];
  fromSnapshot.frame = fromView.frame;
  UIView *containerView = [transitionContext containerView];
  [containerView addSubview:toView];
  [containerView insertSubview:fromSnapshot belowSubview:toView];
  [fromView removeFromSuperview];
  [self updateViewToFinalPosition:toView containerView:containerView];
  
  NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
  [UIView animateWithDuration:animationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut  animations:^{
  
    [self updateViewToInitialPosition:toView containerView:containerView];
    
  } completion:^(BOOL finished) {
    
    [transitionContext completeTransition:YES];
    
  }];
  
}

@end



@implementation OMNTapView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchDown];
  }
  return self;
}

- (void)tap {
  if (self.didTapBlock) {
    self.didTapBlock();
  }
}


@end
