//
//  OMNOrder+tipButton.m
//  omnom
//
//  Created by tea on 07.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder+tipButton.h"
#import "OMNTipButton.h"
#import "OMNUtils.h"

@implementation OMNOrder (tipButton)

- (NSString *)titleForAmount:(long long)amount {
  if (self.enteredAmount) {
    double percent = 100.*(double)amount/self.enteredAmount;
    return [NSString stringWithFormat:@"%.0f%%\n%@", percent, [OMNUtils evenCommaStringFromKop:amount]];
  }
  else {
    return [OMNUtils evenCommaStringFromKop:amount];
  }
}

- (NSString *)titleForPercent:(double)percent {
  long long amount = (percent*0.01)*self.enteredAmount;
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
  else if (self.enteredAmount > self.tipsThreshold) {
    
    [tipButton setTitle:[NSString stringWithFormat:@"%.0f%%", tip.percent] forState:UIControlStateNormal];
    [tipButton setTitle:[self titleForPercent:tip.percent] forState:UIControlStateSelected];
    
  }
  else {
    
    NSString *title = [OMNUtils evenCommaStringFromKop:tip.amount];
    [tipButton setTitle:title forState:UIControlStateNormal];
    [tipButton setTitle:title forState:UIControlStateSelected];
    
  }
  
}

@end
