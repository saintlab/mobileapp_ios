//
//  GTips.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GTip.h"
#import <TSCurrencyTextField.h>
@interface GTips : NSObject

@property (nonatomic, assign) double calculationValue;
@property (nonatomic, strong, readonly) GTip *customTip;
@property (nonatomic, strong, readonly) NSArray *tips;

- (instancetype)initWithTips:(NSArray *)tips;

- (void)setCustomTipAmount:(double)amount;
- (void)setCustomTipPercentValue:(double)percentValue;

- (void)updateAmountField:(TSCurrencyTextField *)amountTF percentTF:(TSCurrencyTextField *)percentTF;

- (void)updateTipsSelector:(UISegmentedControl *)tipsSelector;

@end
