//
//  GCalculationAmount.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

@class OMNTipButton;

@interface OMNCalculationAmount : NSObject

- (instancetype)initOrder:(OMNOrder *)order;

@property (nonatomic, strong, readonly) NSArray *tips;

@property (nonatomic, assign, readonly) double expectedValue;

@property (nonatomic, assign, readonly) double totalValue;

@property (nonatomic, assign, readonly) double tipAmount;

@property (nonatomic, assign) double enteredAmount;

@property (nonatomic, assign) NSInteger selectedTipIndex;

@property (nonatomic, assign) double customTipAmount;

- (BOOL)paymentValueIsTooHigh;

- (void)configureTipButton:(OMNTipButton *)tipButton;

@end
