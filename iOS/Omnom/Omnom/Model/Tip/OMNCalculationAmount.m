//
//  GCalculationAmount.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculationAmount.h"
#import "OMNTipButton.h"
#import "OMNUtils.h"

@implementation OMNCalculationAmount {
  OMNOrder *_order;
}

@dynamic selectedTipIndex;

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
    
    _order = order;
    _tips = order.tips;
    _expectedValue = MAX(0ll, order.total - order.paid_amount);
    _enteredAmount = _expectedValue;
    
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

- (void)setEnteredAmount:(long long)enteredAmount {
  
  [self willChangeValueForKey:NSStringFromSelector(@selector(enteredAmount))];
  _enteredAmount = enteredAmount;
  [self didChangeValueForKey:NSStringFromSelector(@selector(enteredAmount))];
  
}

- (long long)totalValue {
  
  return (_enteredAmount + self.tipAmount);
  
}

- (long long)tipAmount {
  
  long long tipAmount = 0ll;
  OMNTip *selectedTip = self.selectedTip;
  
  if (selectedTip.amount &&
      (selectedTip.custom || _enteredAmount < _order.tipsThreshold)) {
    
    tipAmount = selectedTip.amount;
    
  }
  else {
    tipAmount = _enteredAmount * selectedTip.percent * 0.01;
  }
  
  tipAmount = 100LL*ceil(tipAmount*0.01L);

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

- (long long)customTipAmount {
  
  OMNTip *customTip = _tips[3];
  return (customTip.percent*0.01)*_expectedValue;
  
}

- (OMNTip *)customTip {
  return _tips[3];
}

- (NSString *)titleForAmount:(long long)amount {
  if (_expectedValue) {
    double percent = 100.*(double)amount/_expectedValue;
    return [NSString stringWithFormat:@"%.0f%%\n%@", percent, [OMNUtils evenCommaStringFromKop:amount]];
  }
  else {
    return [OMNUtils evenCommaStringFromKop:amount];
  }
}

- (NSString *)titleForPercent:(double)percent {
  long long amount = (percent*0.01)*_enteredAmount;
  NSString *title = [NSString stringWithFormat:@"%.0f%%\n%@", percent, [OMNUtils evenCommaStringFromKop:amount]];
  return title;
}

- (void)configureTipButton:(OMNTipButton *)tipButton {
  
  OMNTip *tip = tipButton.tip;
  
  if (tip.custom) {
    
    NSString *title = (tip.amount) ? ([self titleForAmount:tip.amount]) : ([self titleForPercent:tip.percent]);
    [tipButton setTitle:NSLocalizedString(@"Другой", nil) forState:UIControlStateNormal];
    [tipButton setTitle:title forState:UIControlStateSelected];
    
  }
  else if (_enteredAmount > _order.tipsThreshold) {
    
    [tipButton setTitle:[NSString stringWithFormat:@"%.0f%%", tip.percent] forState:UIControlStateNormal];
    [tipButton setTitle:[self titleForPercent:tip.percent] forState:UIControlStateSelected];
    
  }
  else {
    
    NSString *title = [OMNUtils evenCommaStringFromKop:tip.amount];
    [tipButton setTitle:title forState:UIControlStateNormal];
    [tipButton setTitle:title forState:UIControlStateSelected];
    
  }
  
}

- (BOOL)paymentValueIsTooHigh {
  
  return self.enteredAmount > 1.5 * self.expectedValue;
  
}

@end
