//
//  GTip.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNTip : NSObject

@property (nonatomic, assign) long long amount;
@property (nonatomic, assign) double percent;
@property (nonatomic, assign) BOOL custom;
@property (nonatomic, assign) BOOL selected;

+ (instancetype)tipWithPercent:(double)percent;

- (instancetype)initWithAmount:(long long)amount percent:(double)percent;

@end
