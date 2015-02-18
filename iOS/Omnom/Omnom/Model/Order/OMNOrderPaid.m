//
//  OMNOrderPaid.m
//  omnom
//
//  Created by tea on 22.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderPaid.h"

@implementation OMNOrderPaid

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
 
    if ([jsonData[@"paid_amount"] respondsToSelector:@selector(longLongValue)]) {
      _total_amount = [jsonData[@"paid_amount"] longLongValue];
    }

    if ([jsonData[@"paid_tip"] respondsToSelector:@selector(longLongValue)]) {
      _tip_amount = [jsonData[@"paid_tip"] longLongValue];
    }
    
  }
  return self;
}

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
