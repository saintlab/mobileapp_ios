//
//  OMNAcquiringTransaction.m
//  omnom
//
//  Created by tea on 04.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNAcquiringTransaction.h"

@interface OMNAcquiringTransaction ()

@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) OMNUser *user;

@end

@implementation OMNAcquiringTransaction

- (instancetype)initWithUser:(OMNUser *)user {
  self = [super init];
  if (self) {
    
    _type = @"none";
    self.user = user;
    self.order_id = @"";
    self.wish_id = @"";
    self.table_id = @"";
    self.restaurant_id = @"";
  }
  return self;
}

- (instancetype)initWithOrder:(OMNOrder *)order user:(OMNUser *)user {
  self = [self initWithUser:user];
  if (self) {
    
    self.type = @"order";

  }
  return self;
}

- (instancetype)initWithWish:(OMNWish *)wish user:(OMNUser *)user {
  self = [self initWithUser:user];
  if (self) {
    
    self.type = @"wish";
    
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

- (void)payWithCard:(OMNBankCardInfo *)bankCardInfo completion:(OMNPaymentDidFinishBlock)completionBlock {
  //do nothing
}

@end
