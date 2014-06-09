//
//  GCalculationAmount.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTip.h"

@class OMNTipButton;

@interface OMNCalculationAmount : NSObject

- (instancetype)initWithTips:(NSArray *)tips tipsThreshold:(double)tipsThreshold total:(double)total;

@property (nonatomic, strong, readonly) NSArray *tips;

@property (nonatomic, assign, readonly) double expectedValue;

@property (nonatomic, assign, readonly) double totalValue;

@property (nonatomic, assign) double enteredAmount;

@property (nonatomic, assign) NSInteger selectedTipIndex;

@property (nonatomic, assign) double customTipAmount;

- (void)configureTipButton:(OMNTipButton *)tipButton;

@end
