//
//  OMNTestBankCardsModel.m
//  omnom
//
//  Created by tea on 18.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTestBankCardsModel.h"
#import "OMNBankCard.h"
#import "OMNBankCardMediator.h"
#import "OMNPaymentNotificationControl.h"
#import "OMNAuthorisation.h"

@implementation OMNTestBankCardsModel

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock {
  
  OMNBankCard *bankCard = [[OMNBankCard alloc] init];
  bankCard.id = @"1";
  bankCard.demo = YES;
  bankCard.association = @"visa";
  bankCard.masked_pan = @"4111 .... .... 1111";
  bankCard.status = kOMNBankCardStatusRegistered;
  self.cards = [NSMutableArray arrayWithObject:bankCard];
  [self updateCardSelection];
  completionBlock();
  
}

- (void)payForOrder:(OMNOrder *)order cardInfo:(OMNBankCardInfo *)bankCardInfo completion:(dispatch_block_t)completionBlock failure:(void (^)(NSError *, NSDictionary *))failureBlock {
  
  [self.bankCardMediator beginPaymentProcessWithPresentBlock:^(OMNPaymentFinishBlock paymentFinishBlock) {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      OMNPaymentDetails *paymentDetails = [OMNPaymentDetails paymentDetailsWithTotalAmount:order.enteredAmountWithTips tipAmount:order.tipAmount userID:[OMNAuthorisation authorisation].user.id userName:[OMNAuthorisation authorisation].user.name];
      [OMNPaymentNotificationControl showWithPaymentDetails:paymentDetails];
      paymentFinishBlock(nil, completionBlock);
      
    });
    
  }];
  
}

@end
