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

- (long long)totalAmount {
  
  return (self.enteredAmount + self.tipAmount);
  
}

- (void)payWithCard:(OMNBankCardInfo *)bankCardInfo completion:(dispatch_block_t)completionBlock failure:(void (^)(OMNError *))failureBlock {
  //do nothing
}

@end
