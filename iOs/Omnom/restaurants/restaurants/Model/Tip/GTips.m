//
//  GTips.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GTips.h"



@implementation GTips {
}

@dynamic customTip;

- (instancetype)initWithTips:(NSArray *)tips {
  self = [super init];
  if (self) {
    NSAssert(tips.count == 4, @"wrong tips count");
    _tips = tips;
  }
  return self;
}

- (GTip *)customTip {
  return _tips[3];
}

- (void)setCustomTipAmount:(double)amount {
  
  self.customTip.amount = amount;
  
}

- (void)setCustomTipPercentValue:(double)percentValue {
  
  self.customTip.percent = percentValue;
  
}

- (void)setCalculationValue:(double)calculationValue {
  _calculationValue = calculationValue;
  
  [_tips enumerateObjectsUsingBlock:^(GTip *tip, NSUInteger idx, BOOL *stop) {
    tip.calculationValue = calculationValue;
  }];
  
}

- (void)updateAmountField:(TSCurrencyTextField *)amountTF percentTF:(TSCurrencyTextField *)percentTF {
  
  amountTF.amount = @(self.customTip.amount);
  percentTF.amount = @(self.customTip.percent);
  
}

- (void)updateTipsSelector:(UISegmentedControl *)tipsSelector {
  
    
}

@end
