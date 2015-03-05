//
//  OMNAcquiringTransaction.m
//  omnom
//
//  Created by tea on 04.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNAcquiringTransaction.h"

@implementation OMNAcquiringTransaction

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
  }
  return self;
}

- (instancetype)initWithWish:(OMNWish *)wish {
  self = [super init];
  if (self) {
  }
  return self;
}

- (long long)total_amount {
  
  return (self.bill_amount + self.tips_amount);
  
}

- (double)tips_percent {
  
  double tips_percent = (self.bill_amount) ? (100.0*((double)self.tips_amount/self.bill_amount)) : (0.0);
  return tips_percent;
  
}

- (void)payWithCard:(OMNBankCardInfo *)bankCardInfo completion:(dispatch_block_t)completionBlock failure:(void (^)(OMNError *))failureBlock {
  //do nothing
}

@end
