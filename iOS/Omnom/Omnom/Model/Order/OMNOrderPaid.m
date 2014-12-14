//
//  OMNOrderPaid.m
//  omnom
//
//  Created by tea on 22.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderPaid.h"

@implementation OMNOrderPaid

- (instancetype)initWithTotal:(long long)total tip:(long long)tip {
  self = [super init];
  if (self) {
    _total_amount = total;
    _tip_amount = tip;
  }
  return self;
}

- (long long)net_amount {
  
  long long net_amount = MAX(0ll, self.total_amount - self.tip_amount);
  return net_amount;
  
}

@end
