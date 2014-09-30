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
- (OMNStyle *)styleForClass:(Class)class;
- (NSTimeInterval)animationDurationForKey:(NSString *)key;
- (void)reset;

@end
