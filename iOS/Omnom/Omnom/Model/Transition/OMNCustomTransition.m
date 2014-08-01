//
//  OMNCustomTransition.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCustomTransition.h"
#import <OMNStyler.h>

@implementation OMNCustomTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return [[OMNStyler styler] animationDurationForKey:NSStringFromClass(self.class)];
}

+ (NSArray *)keys {
  return @[];
}

+ (NSString *)keyFromClass:(Class)fromClass toClass:(Class)toClass {
  return [NSString stringWithFormat:@"%@+%@", NSStringFromClass(fromClass), NSStringFromClass(toClass)];
}

@end
