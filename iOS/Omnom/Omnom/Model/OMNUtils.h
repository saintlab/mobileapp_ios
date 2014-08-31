//
//  OMNUtils.h
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kRubleSign;
extern NSString * const kCommaString;

@interface OMNUtils : NSObject

+ (NSString *)moneyStringFromKop:(long long)kop;
+ (NSString *)commaStringFromKop:(long long)kop;

@end
