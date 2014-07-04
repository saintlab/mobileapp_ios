//
//  OMNStyler.h
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStyle.h"

@interface OMNStyler : NSObject

+ (instancetype)styler;

- (OMNStyle *)styleForClass:(Class)class;

@end
