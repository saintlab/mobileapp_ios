//
//  OMNLoaderView.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoaderView.h"

@implementation OMNLoaderView {
  CAShapeLayer *_loaderLayer;
  NSDate *_startAnimationDate;
  NSTimeInterval _totalDuration;
  dispatch_block_t _completionBlock;
}

- (instancetype)initWithInnerFrame:(CGRect)frame {
  
  CGFloat loaderWidth = 10.0f;
  CGRect layerFrame = CGRectInset(frame, -loaderWidth/2.0f, -loaderWidth/2.0f);
  layerFrame.origin = CGPointZero;
  self = [super initWithFrame:layerFrame];
  if (self) {
    
    CGFloat loaderRadius = layerFrame.size.width/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:loaderRadius];
    
    _loaderLayer = [CAShapeLayer layer];
    _loaderLayer.frame = self.bounds;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    _loaderLayer.path = path.CGPath;
    _loaderLayer.strokeColor = [[UIColor whiteColor] CGColor];
    _loaderLayer.fillColor = nil;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    _loaderLayer.hidden = YES;
    [CATransaction commit];
    _loaderLayer.lineWidth = loaderWidth;

    _loaderLayer.lineJoin = kCALineJoinRound;
    [CATransaction commit];
    [self.layer addSublayer:_loaderLayer];
  }
  return self;
}

- (void)startAnimating:(NSTimeInterval)duration {
  _loaderLayer.hidden = NO;
  
  _startAnimationDate = [NSDate date];
  _totalDuration = duration;
  [self decreaseAnimationDuration:0 start:YES];
  
}

- (void)setProgress:(CGFloat)progress {
  
  CALayer *currentLayer = (CALayer *)[_loaderLayer presentationLayer];
  CGFloat currentProgress = [(NSNumber *)[currentLayer valueForKeyPath:@"strokeEnd"] floatValue];
  if (progress > currentProgress) {
    CGFloat decreaseTime = (progress - currentProgress)*_totalDuration;
    [self decreaseAnimationDuration:decreaseTime start:NO];
  }
}

- (void)completeAnimation:(dispatch_block_t)completionBlock {
  _completionBlock = completionBlock;
  
  CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  
  pathAnimation.duration = 0.3;
  pathAnimation.delegate = self;
  pathAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.53 :1.25 :.61 :.89];
  
  CALayer *currentLayer = (CALayer *)[_loaderLayer presentationLayer];
  float currentAngle = [(NSNumber *)[currentLayer valueForKeyPath:@"strokeEnd"] floatValue];
  pathAnimation.fromValue = @(currentAngle);
  pathAnimation.toValue = @(1.0f);
  _loaderLayer.strokeEnd = 1.0f;
  [_loaderLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

- (void)stop {
  
  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
  _loaderLayer.hidden = YES;
  [CATransaction commit];

}

- (void)decreaseAnimationDuration:(NSTimeInterval)decreaseDuration start:(BOOL)start {
  
  CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  
  NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:_startAnimationDate];
  NSTimeInterval duration = MAX(0.1, _totalDuration - elapsedTime - decreaseDuration);
  pathAnimation.duration = duration;
  pathAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.53 :1.25 :.61 :.89];
  
  if (start) {
    pathAnimation.fromValue = @(0);
  }
  else {
    CALayer *currentLayer = (CALayer *)[_loaderLayer presentationLayer];
    float currentAngle = [(NSNumber *)[currentLayer valueForKeyPath:@"strokeEnd"] floatValue];
    pathAnimation.fromValue = @(currentAngle);
  }
  pathAnimation.toValue = @(0.99);
  _loaderLayer.strokeEnd = 0.99;
  [_loaderLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
  
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (flag) {
    _loaderLayer.hidden = YES;
    if (_completionBlock) {
      _completionBlock();
    }
  }
}


@end
