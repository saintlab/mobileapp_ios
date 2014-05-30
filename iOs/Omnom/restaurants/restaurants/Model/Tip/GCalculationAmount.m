//
//  GCalculationAmount.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GCalculationAmount.h"

@implementation GCalculationAmount {
  
}

- (instancetype)initWithExpectedValue:(double)expectedValue tips:(NSArray *)tips {
  self = [super init];
  if (self) {
    NSAssert(tips.count == 4, @"wrong tips count");
    _tips = tips;

    NSAssert(expectedValue > 0, @"wrong expected value");
    _expectedValue = expectedValue;
    self.enteredAmount = expectedValue;
    
  }
  return self;
}

- (void)setSelectedTipIndex:(NSInteger)selectedTipIndex {
  
  if (selectedTipIndex == -1) {
    _selectedTipIndex = _tips.count - 1;
  }
  else {
    _selectedTipIndex = MIN(selectedTipIndex, _tips.count - 1);
  }
  
}

- (void)setEnteredAmount:(double)enteredAmount {

  _enteredAmount = enteredAmount;
  _percentValue = _enteredAmount / _expectedValue;
  
  [_tips enumerateObjectsUsingBlock:^(GTip *tip, NSUInteger idx, BOOL *stop) {
    tip.calculationValue = enteredAmount;
  }];
  
}

- (double)percentOfAmount:(double)amount {
  
  return amount / _expectedValue;
  
}

- (double)totalValue {
  
  return (_enteredAmount + self.selectedTip.amount);
  
}

- (GTip *)selectedTip {
  return _tips[self.selectedTipIndex];
}

- (double)customTipAmount {
  
  GTip *customTip = _tips[3];
  return customTip.amount;
  
}

- (void)setCustomTipAmount:(double)customTipAmount {
  GTip *customTip = _tips[3];
  customTip.amount = customTipAmount;
}

@end
