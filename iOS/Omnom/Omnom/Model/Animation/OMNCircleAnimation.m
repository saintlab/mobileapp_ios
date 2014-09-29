//
//  OMNCircleAnimation.m
//  omnom
//
//  Created by tea on 29.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleAnimation.h"
#import <BlocksKit.h>

@implementation OMNCircleAnimation {
  UIButton *_circleButton;
  UIImageView *_iv1;
  UIImageView *_iv2;
  UIImageView *_iv3;
  NSTimer *_circleAnimationTimer;
  
  UIButton *_placeholderCircleButton;
}

- (void)dealloc {
  
  [self stopTimer];
  [self removeViews];
  
}

- (instancetype)initWithCircleButton:(UIButton *)circleButton {
  self = [super init];
  if (self) {
    _circleButton = circleButton;
  }
  return self;
}

- (void)beginCircleAnimationIfNeededWithImage:(UIImage *)image {
  
  if (_circleAnimationTimer) {
    return;
  }

  UIImage *circleBackground = [_circleButton backgroundImageForState:UIControlStateNormal];
  
  _placeholderCircleButton = [[UIButton alloc] initWithFrame:_circleButton.frame];
  [_placeholderCircleButton setImage:image forState:UIControlStateNormal];
  [_placeholderCircleButton setBackgroundImage:circleBackground forState:UIControlStateNormal];
  _placeholderCircleButton.userInteractionEnabled = NO;
  [_circleButton.superview addSubview:_placeholderCircleButton];
  
  _iv1 = [[UIImageView alloc] initWithImage:circleBackground];
  _iv1.center = _circleButton.center;
  [_circleButton.superview insertSubview:_iv1 belowSubview:_circleButton];
  
  _iv2 = [[UIImageView alloc] initWithImage:circleBackground];
  _iv2.alpha = 0.5f;
  _iv2.center = _circleButton.center;
  [_circleButton.superview insertSubview:_iv2 belowSubview:_circleButton];
  
  _iv3 = [[UIImageView alloc] initWithImage:circleBackground];
  _iv3.alpha = 0.25f;
  _iv3.center = _circleButton.center;
  [_circleButton.superview insertSubview:_iv3 belowSubview:_circleButton];
  
  [_circleAnimationTimer invalidate];
  
  CGFloat animationRepeatCount = 3.0f;
  
  NSTimeInterval duration = 2.5;
  NSTimeInterval delay = 0.0f;
  NSTimeInterval animationPause = 3.0;
  NSTimeInterval totalAnimationCicleDuration = duration*animationRepeatCount + animationPause;
  _circleAnimationTimer = [NSTimer bk_scheduledTimerWithTimeInterval:totalAnimationCicleDuration block:^(NSTimer *timer) {
    
    [UIView transitionWithView:_iv1 duration:duration/2. options:UIViewAnimationOptionAutoreverse animations:^{
      
      [UIView setAnimationRepeatCount:animationRepeatCount - 0.5f];
      _iv1.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
      
    } completion:^(BOOL finished) {
      
      [UIView animateWithDuration:duration/2. animations:^{
        _iv1.transform = CGAffineTransformIdentity;
      }];
      
    }];
    
    [UIView animateWithDuration:duration delay:delay options:0 animations:^{
      [UIView setAnimationRepeatCount:animationRepeatCount];
      
      _iv2.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
      _iv3.transform = CGAffineTransformMakeScale(5.0f, 5.0f);
      
      _iv2.alpha = 0.0f;
      _iv3.alpha = 0.0f;
      
    } completion:^(BOOL finished) {
      _iv2.transform = CGAffineTransformIdentity;
      _iv3.transform = CGAffineTransformIdentity;
      
      _iv2.alpha = 0.5f;
      _iv3.alpha = 0.25f;
    }];
    
  } repeats:YES];
  [_circleAnimationTimer fire];
}

- (void)stopTimer {
  [_circleAnimationTimer invalidate], _circleAnimationTimer = nil;
}

- (void)removeViews {
  
  [_iv1 removeFromSuperview], _iv1 = nil;
  [_iv2 removeFromSuperview], _iv2 = nil;
  [_iv3 removeFromSuperview], _iv3 = nil;
  [_placeholderCircleButton removeFromSuperview], _placeholderCircleButton = nil;
  
}

- (void)finishCircleAnimation {
  
  [self stopTimer];
  
  [UIView animateWithDuration:0.50 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    
    _iv1.alpha = 0.0f;
    _iv2.alpha = 0.0f;
    _iv3.alpha = 0.0f;
    _iv1.transform = CGAffineTransformIdentity;
    _iv2.transform = CGAffineTransformIdentity;
    _iv3.transform = CGAffineTransformIdentity;
    _placeholderCircleButton.alpha = 0.0f;
    
  } completion:^(BOOL finished) {
    
    [self removeViews];
    
  }];
  
}

@end
