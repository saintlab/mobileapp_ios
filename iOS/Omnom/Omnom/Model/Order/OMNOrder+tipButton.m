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
  
  return [OMNUtils evenCommaStringFromKop:amount];

}

- (NSString *)titleForPercent:(double)percent {

  NSString *title = [NSString stringWithFormat:@"%.0f%%", percent];
  return title;
  
}

- (void)configureTipButton:(OMNTipButton *)tipButton {
  
  OMNTip *tip = tipButton.tip;
  
  NSString *normalTitle = @"";
  NSString *selectedTitle = @"";
  
  if (tip.custom) {
    
    normalTitle = NSLocalizedString(@"Другой", nil);
    selectedTitle = [self titleForPercent:tip.percent];
    
  }
  else if (self.enteredAmount > self.percentTipsThreshold) {

    normalTitle = [self titleForPercent:tip.percent];
    selectedTitle = normalTitle;
    
  }
  else {
    
    normalTitle = [OMNUtils evenCommaStringFromKop:[tip amountForValue:self.enteredAmount]];
    selectedTitle = normalTitle;
    
  }
  
  [tipButton setTitle:normalTitle forState:UIControlStateNormal];
  [tipButton setTitle:selectedTitle forState:UIControlStateSelected];
  [tipButton setTitle:selectedTitle forState:UIControlStateSelected|UIControlStateHighlighted];

}

@end
