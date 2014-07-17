//
//  OMNStyle.h
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNStyle : NSObject

- (instancetype)initWithJsonData:(NSData *)data;

- (UIFont *)fontForKey:(NSString *)key;

- (NSString *)stringForKey:(NSString *)key;
- (UIColor *)colorForKey:(NSString *)key;

@end
