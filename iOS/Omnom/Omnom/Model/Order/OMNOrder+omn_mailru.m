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
#import "OMNOrder+network.h"

@interface OMNMailRuPaymentInfo (omn_order)

- (void)omn_updateWithBill:(OMNBill *)bill;

@end

@implementation OMNOrder (omn_mailru)

- (void)getPaymentInfoForUser:(OMNUser *)user cardInfo:(OMNMailRuCardInfo *)cardInfo copmletion:(OMNMailRuPaymentInfoBlock)completionBlock failure:(void (^)(NSError *error))failureBlock {
  
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  paymentInfo.cardInfo = cardInfo;
  paymentInfo.user_login = user.id;
  paymentInfo.user_phone = user.phone;
  paymentInfo.order_message = @"message";
  paymentInfo.extra.tip = self.tipAmount;
  paymentInfo.extra.restaurant_id = @"1";
  paymentInfo.order_amount = @(self.enteredAmountWithTips/100.);
  
  if (self.bill) {
    [paymentInfo omn_updateWithBill:self.bill];
    completionBlock(paymentInfo);
  }
  else {
    
    __weak typeof(self)weakSelf = self;
    [self createBill:^(OMNBill *bill) {
      
      weakSelf.bill = bill;
      [paymentInfo omn_updateWithBill:bill];
      completionBlock(paymentInfo);
      
    } failure:failureBlock];
    
  }
  
}

@end

@implementation OMNMailRuPaymentInfo (omn_order)

- (void)omn_updateWithBill:(OMNBill *)bill {
  self.order_id = bill.id;
  self.extra.restaurant_id = bill.mail_restaurant_id;
}

@end
