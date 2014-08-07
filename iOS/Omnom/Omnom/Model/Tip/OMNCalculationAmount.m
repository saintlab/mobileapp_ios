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
  OMNOrder *_order;
}

@dynamic selectedTipIndex;

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
    
    _tips = order.tips;
    _expectedValue = order.total;
    _enteredAmount = order.total;

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
  
  long long tipAmount = 0.;
  OMNTip *selectedTip = self.selectedTip;
  
  if (_enteredAmount > _order.tipsThreshold &&
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

- (long long)customTipAmount {
  
  OMNTip *customTip = _tips[3];
  return customTip.amount;
  
}

- (void)setCustomTipAmount:(long long)customTipAmount {
  
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
      title = [NSString stringWithFormat:@"%.0f%%\n%.0fi", percent, tip.amount*0.01];
    }
    [tipButton setTitle:title forState:UIControlStateNormal];
    [tipButton setTitle:title forState:UIControlStateSelected];
    
  }
  else if (_enteredAmount > _order.tipsThreshold) {
    
    [tipButton setTitle:[NSString stringWithFormat:@"%.0f%%", tip.percent] forState:UIControlStateNormal];
    [tipButton setTitle:[NSString stringWithFormat:@"%.0f%%\n%.0fi", tip.percent, 0.01*(tip.percent*0.01)*_enteredAmount] forState:UIControlStateSelected];
    
  }
  else {
    
    [tipButton setTitle:[NSString stringWithFormat:@"%.0fi", tip.amount*0.01] forState:UIControlStateNormal];
    [tipButton setTitle:[NSString stringWithFormat:@"%.0fi", tip.amount*0.01] forState:UIControlStateSelected];
    
  }
  
}

- (BOOL)paymentValueIsTooHigh {
  
  return self.enteredAmount > 1.5 * self.expectedValue;
  
}

@end
