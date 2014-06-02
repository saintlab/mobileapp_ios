//
//  GTip.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTip.h"

@implementation OMNTip

@synthesize percent = _percent;
@synthesize amount = _amount;

+ (instancetype)tipWithPercent:(double)percent {
  
  OMNTip *tip = [[OMNTip alloc] init];
  tip.percent = percent;

  return tip;
}

- (instancetype)initWithAmount:(double)amount percent:(double)percent {
  self = [super init];
  if (self) {
    _amount = amount;
    _percent = percent;
  }
  return self;
}

- (double)percent {
  
  if (_percent > 0) {
    return _percent;
  }
  else if (_calculationValue > 0){
    return 100 * (_amount / _calculationValue);
  }
  else {
    return 0.;
  }
  
}

- (void)setPercent:(double)percent {
  
  _percent = percent;
  _amount = 0.;
  
}

- (double)amount {
  
  if (_amount > 0) {
    return _amount;
  }
  else {
    return _calculationValue * _percent * 0.01;
  }
  
}

- (void)setAmount:(double)amount {
  
  _amount = amount;
  _percent = 0.;
  
}

- (NSString *)title {
  
  if (self.percent > 0) {
    return [NSString stringWithFormat:@"%.0f%%", self.percent];
  }
  else {
    return NSLocalizedString(@"Другой", nil);
  }
  
}

- (NSString *)selectedTitle {
  
  if (self.percent > 0) {
    return [NSString stringWithFormat:@"%.0f%%\n%.0f", self.percent, self.amount];
  }
  else {
    return NSLocalizedString(@"Другой", nil);
  }
  
}

@end
