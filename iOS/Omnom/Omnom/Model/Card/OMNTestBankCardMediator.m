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
#import "OMNTestBankCardsModel.h"

@implementation OMNTestBankCardMediator

- (void)payWithCardInfo:(OMNBankCardInfo *)bankCardInfo {
  
  @weakify(self)
  [self showPaymentVCWithDidPresentBlock:^(OMNPaymentDidFinishBlock paymentDidFinishBlock) {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      @strongify(self)
      OMNPaymentDetails *paymentDetails = [OMNPaymentDetails paymentDetailsWithTotalAmount:self.acquiringTransaction.total_amount tipAmount:self.acquiringTransaction.tips_amount userID:[OMNAuthorization authorization].user.id userName:[OMNAuthorization authorization].user.name];
      [OMNPaymentNotificationControl showWithPaymentDetails:paymentDetails];
      paymentDidFinishBlock(nil, nil);
      
    });
    
  }];
  
}

- (OMNBankCardsModel *)bankCardsModel {
  return [[OMNTestBankCardsModel alloc] init];
}

@end
