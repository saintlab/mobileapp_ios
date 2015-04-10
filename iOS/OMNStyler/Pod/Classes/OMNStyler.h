//
//  OMNStyler.h
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStyle.h"

#define kUseRemoteTimings 0

@interface OMNStyler : NSObject

+ (instancetype)styler;

- (NSNumber *)leftOffset;
- (NSNumber *)bottomToolbarHeight;

+ (UIColor *)toolbarColor;
+ (UIColor *)blueColor;
+ (UIColor *)redColor;
+ (UIColor *)greenColor;
+ (UIColor *)linkColor;
+ (UIColor *)activeLinkColor;
+ (UIColor *)greyColor;

+ (UIEdgeInsets)buttonEdgeInsets;
- (OMNStyle *)styleForClass:(Class)class;
- (NSTimeInterval)animationDurationForKey:(NSString *)key;
- (void)reset;

@end
