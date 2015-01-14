//
//  OMNTestBankCardMediator.m
//  omnom
//
//  Created by tea on 20.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTestBankCardMediator.h"
#import "OMNPaymentNotificationControl.h"
#import "OMNAuthorization.h"

@implementation OMNTestBankCardMediator

- (void)payWithCardInfo:(OMNBankCardInfo *)bankCardInfo {
  
  OMNOrder *order = self.order;
  [self showPaymentVCWithDidPresentBlock:^(OMNPaymentDidFinishBlock paymentDidFinishBlock) {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      OMNPaymentDetails *paymentDetails = [OMNPaymentDetails paymentDetailsWithTotalAmount:order.enteredAmountWithTips tipAmount:order.tipAmount userID:[OMNAuthorization authorisation].user.id userName:[OMNAuthorization authorisation].user.name];
      [OMNPaymentNotificationControl showWithPaymentDetails:paymentDetails];
      paymentDidFinishBlock(nil);
      
    });
    
  }];
  
}

@end
