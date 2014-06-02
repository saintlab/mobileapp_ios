//
//  GCalculationAmount.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTip.h"

@interface GCalculationAmount : NSObject

- (instancetype)initWithExpectedValue:(double)expectedValue tips:(NSArray *)tips;

@property (nonatomic, assign) BOOL tipsMode;

@property (nonatomic, strong, readonly) NSArray *tips;

@property (nonatomic, assign, readonly) double expectedValue;

@property (nonatomic, assign, readonly) double totalValue;

@property (nonatomic, assign, readonly) double percentValue;

@property (nonatomic, assign) double enteredAmount;

@property (nonatomic, assign) NSInteger selectedTipIndex;

@property (nonatomic, assign) double customTipAmount;

- (double)percentOfAmount:(double)amount;

@end
