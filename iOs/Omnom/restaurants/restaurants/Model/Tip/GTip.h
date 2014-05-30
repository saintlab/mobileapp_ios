//
//  GTip.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTip : NSObject

@property (nonatomic, assign) double amount;
@property (nonatomic, assign) double percent;
@property (nonatomic, assign) double calculationValue;

+ (instancetype)tipWithPercent:(double)percent;

- (NSString *)title;
- (NSString *)selectedTitle;

@end
