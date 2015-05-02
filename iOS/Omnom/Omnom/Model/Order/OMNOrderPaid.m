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
 
    if (jsonData[@"paid"]) {
      _total_amount = [jsonData[@"paid"][@"amount"] omn_longLongValueSafe];
      _tip_amount = [jsonData[@"paid"][@"tip"] omn_longLongValueSafe];
    }
    else {
      _total_amount = [jsonData[@"paid_amount"] omn_longLongValueSafe];
      _tip_amount = [jsonData[@"paid_tip"] omn_longLongValueSafe];
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
