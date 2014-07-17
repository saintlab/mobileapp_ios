//
//  GCalculationAmount.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculationAmount.h"
#import "OMNTipButton.h"

@implementation OMNCalculationAmount {
  double _tipsThreshold;
}

@dynamic selectedTipIndex;

- (instancetype)initWithTips:(NSArray *)tips tipsThreshold:(double)tipsThreshold total:(double)total {
  self = [super init];
  if (self) {
    
    _tips = tips;
    _expectedValue = total;
    _tipsThreshold = tipsThreshold;
    self.enteredAmount = total;
    
  }
  return self;
}

- (void)setSelectedTipIndex:(NSInteger)selectedTipIndex {
  
  [self.tips enumerateObjectsUsingBlock:^(OMNTip *tip, NSUInteger idx, BOOL *stop) {
    
    tip.selected = (idx == selectedTipIndex);
    
  }];

}

- (NSInteger)selectedTipIndex {
  
  __block NSInteger selectedTipIndex = -1;
  [self.tips enumerateObjectsUsingBlock:^(OMNTip *tip, NSUInteger idx, BOOL *stop) {
    
    if (tip.selected) {
      selectedTipIndex = idx;
      *stop = YES;
    }
    
  }];

  return selectedTipIndex;
  
}

- (void)setEnteredAmount:(double)enteredAmount {

  [self willChangeValueForKey:NSStringFromSelector(@selector(enteredAmount))];
  _enteredAmount = enteredAmount;
  [self didChangeValueForKey:NSStringFromSelector(@selector(enteredAmount))];
  
}

- (double)totalValue {
  
  return (_enteredAmount + self.tipAmount);
  
}

- (double)tipAmount {
  
  double tipAmount = 0.;
  OMNTip *selectedTip = self.selectedTip;
  
  if (_enteredAmount > _tipsThreshold &&
      selectedTip.percent > 0) {
    tipAmount = _enteredAmount * selectedTip.percent * 0.01;
  }
  else {
    tipAmount = selectedTip.amount;
  }
  
  return tipAmount;
  
}

- (OMNTip *)selectedTip {
  
  __block OMNTip *selectedTip = nil;
  [self.tips enumerateObjectsUsingBlock:^(OMNTip *tip, NSUInteger idx, BOOL *stop) {
    
    if (tip.selected) {
      selectedTip = tip;
      *stop = YES;
    }
    
  }];
  
  return selectedTip;
  
}

- (double)customTipAmount {
  
  OMNTip *customTip = _tips[3];
  return customTip.amount;
  
}

- (void)setCustomTipAmount:(double)customTipAmount {
  
  OMNTip *customTip = _tips[3];
  customTip.amount = customTipAmount;

}

- (void)configureTipButton:(OMNTipButton *)tipButton {
  
  OMNTip *tip = tipButton.tip;
  
  if (tip.percent < 0.01) {

    NSString *title = NSLocalizedString(@"Другой", nil);
    if (tip.amount > 0 &&
        _expectedValue > 0) {
      double percent = 100*tip.amount/_expectedValue;
      title = [NSString stringWithFormat:@"%.0f%%\n%.0fi", percent, tip.amount];
    }
    [tipButton setTitle:title forState:UIControlStateNormal];
    [tipButton setTitle:title forState:UIControlStateSelected];
    
  }
  else if (_enteredAmount > _tipsThreshold) {
    
    [tipButton setTitle:[NSString stringWithFormat:@"%.0f%%", tip.percent] forState:UIControlStateNormal];
    [tipButton setTitle:[NSString stringWithFormat:@"%.0f%%\n%.0fi", tip.percent, tip.percent * 0.01 * _enteredAmount] forState:UIControlStateSelected];
    
  }
  else {
    
    [tipButton setTitle:[NSString stringWithFormat:@"%.0fi", tip.amount] forState:UIControlStateNormal];
    [tipButton setTitle:[NSString stringWithFormat:@"%.0fi", tip.amount] forState:UIControlStateSelected];
    
  }
  
}

- (BOOL)paymentValueIsTooHigh {
  
  return self.enteredAmount > 1.5 * self.expectedValue;
  
}

@end
