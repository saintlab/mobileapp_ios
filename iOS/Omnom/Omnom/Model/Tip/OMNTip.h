//
//  GTip.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNTip : NSObject

@property (nonatomic, assign) double percent;
@property (nonatomic, assign) BOOL custom;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong, readonly) NSArray *amounts;
@property (nonatomic, strong, readonly) NSArray *thresholds;

+ (instancetype)tipWithPercent:(double)percent;
- (instancetype)initWithJsonData:(id)jsonData thresholds:(NSArray *)thresholds;

- (long long)amountForValue:(long long)value;

@end
