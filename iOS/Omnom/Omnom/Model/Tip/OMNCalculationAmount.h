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

- (instancetype)initWithOrder:(OMNOrder *)order;

@property (nonatomic, strong, readonly) NSArray *tips;
@property (nonatomic, strong, readonly) OMNTip *customTip;
@property (nonatomic, assign, readonly) long long expectedValue;
@property (nonatomic, assign, readonly) long long totalValue;
@property (nonatomic, assign, readonly) long long tipAmount;
@property (nonatomic, assign) long long enteredAmount;

@property (nonatomic, assign) NSInteger selectedTipIndex;


- (BOOL)paymentValueIsTooHigh;

- (void)configureTipButton:(OMNTipButton *)tipButton;

@end
