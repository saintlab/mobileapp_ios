//
//  GTip.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTip.h"

@implementation OMNTip {
  
  long long _maxThreshold;
  
}

+ (instancetype)tipWithPercent:(double)percent {
  
  OMNTip *tip = [[OMNTip alloc] init];
  tip.percent = percent;
  return tip;
}

- (instancetype)initWithJsonData:(id)jsonData thresholds:(NSArray *)thresholds {
  self = [super init];
  if (self) {
   
    _amounts = jsonData[@"amounts"];
    _thresholds = thresholds;
    _maxThreshold = [[_thresholds lastObject] longLongValue];
    _percent = [jsonData[@"percent"] doubleValue];
    
  }
  return self;
}

- (long long)amountForValue:(long long)value {
  
  __block long long tipAmount = 0ll;
  if (self.custom ||
      value >= _maxThreshold) {
    
    tipAmount = value * self.percent * 0.01;
    
  }
  else {
    
    [_thresholds enumerateObjectsUsingBlock:^(NSNumber *threshold, NSUInteger idx, BOOL *stop) {
      
      if (value < [threshold longLongValue] &&
          idx < self.amounts.count) {
        
        tipAmount = [self.amounts[idx] longLongValue];
        *stop = YES;
      }
      
    }];
    
  }
  
  return tipAmount;
  
}

@end
