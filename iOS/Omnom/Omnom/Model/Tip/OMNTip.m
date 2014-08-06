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

- (instancetype)initWithAmount:(long long)amount percent:(double)percent {
  self = [super init];
  if (self) {
    _amount = amount;
    _percent = percent;
  }
  return self;
}

@end
