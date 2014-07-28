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
}

- (instancetype)initWithInnerFrame:(CGRect)frame {
  
  CGFloat loaderWidth = 10.0f;
  CGRect layerFrame = CGRectInset(frame, -loaderWidth/2.0f, -loaderWidth/2.0f);
  self = [super initWithFrame:layerFrame];
  
  if (self) {
    CGFloat loaderRadius = layerFrame.size.width/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:loaderRadius];
    
    _loaderLayer = [CAShapeLayer layer];
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
    _loaderLayer.lineJoin = kCALineJoinBevel;
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
  
  NSLog(@"setProgress>%f", progress);
  
  CALayer *currentLayer = (CALayer *)[_loaderLayer presentationLayer];
  CGFloat currentProgress = [(NSNumber *)[currentLayer valueForKeyPath:@"strokeEnd"] floatValue];
  if (progress > currentProgress) {
    CGFloat decreaseTime = (progress - currentProgress)*_totalDuration;
    [self decreaseAnimationDuration:decreaseTime start:NO];
  }
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
  NSTimeInterval duration = _totalDuration - elapsedTime - decreaseDuration;
  pathAnimation.duration = duration;
  pathAnimation.delegate = self;
  pathAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.53 :1.25 :.61 :.89];
  
  if (start) {
    pathAnimation.fromValue = @(0);
  }
  else {
    CALayer *currentLayer = (CALayer *)[_loaderLayer presentationLayer];
    float currentAngle = [(NSNumber *)[currentLayer valueForKeyPath:@"strokeEnd"] floatValue];
    pathAnimation.fromValue = @(currentAngle);
  }
  pathAnimation.toValue = @(1);

  [_loaderLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
  
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (flag) {
    _loaderLayer.hidden = YES;
  }
}


@end
