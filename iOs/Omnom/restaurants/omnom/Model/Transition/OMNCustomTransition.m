//
//  OMNCustomTransition.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCustomTransition.h"

@implementation OMNCustomTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.0;
}

+ (NSString *)key {
  return @"";
}

+ (NSString *)keyFromClass:(Class)fromClass toClass:(Class)toClass {
  return [NSString stringWithFormat:@"%@+%@", NSStringFromClass(fromClass), NSStringFromClass(toClass)];
}

@end
