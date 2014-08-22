//
//  OMNOrder+omn_mailru.m
//  omnom
//
//  Created by tea on 22.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder+omn_mailru.h"
#import <OMNMailRuPaymentInfo.h>
#import "OMNUser.h"

@implementation OMNOrder (omn_mailru)

- (void)getPaymentInfoForUser:(OMNUser *)user cardInfo:(OMNMailRuCardInfo *)cardInfo copmletion:(OMNMailRuPaymentInfoBlock)completionBlock failure:(void (^)(NSError *error))failureBlock {
  
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  paymentInfo.cardInfo = cardInfo;
  paymentInfo.user_login = user.id;
  paymentInfo.user_phone = user.phone;
  paymentInfo.order_message = @"message";
  paymentInfo.extra.tip = self.tipAmount;
  paymentInfo.extra.restaurant_id = @"1";
  paymentInfo.order_amount = @(self.toPayAmount/100.);
  
  if (self.bill_id) {
    paymentInfo.order_id = self.bill_id;
    completionBlock(paymentInfo);
  }
  else {
    
    __weak typeof(self)weakSelf = self;
    [self createBill:^(OMNBill *bill) {
      
      weakSelf.bill_id = bill.id;
      paymentInfo.order_id = bill.id;
      completionBlock(paymentInfo);
      
    } failure:failureBlock];
    
  }
  
}

@end
