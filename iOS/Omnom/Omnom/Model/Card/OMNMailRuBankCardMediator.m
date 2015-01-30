//
//  OMNMailRuBankCardMediator.m
//  omnom
//
//  Created by tea on 19.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRuBankCardMediator.h"
#import "OMNAddBankCardVC.h"
#import "OMNPaymentAlertVC.h"
#import "OMNOperationManager.h"
#import "OMNOrderTansactionInfo.h"
#import "OMNOrder+omn_mailru.h"
#import "OMNMailRUCardConfirmVC.h"
#import "OMNAnalitics.h"
#import <OMNMailRuAcquiring.h>
#import "OMNAuthorization.h"

@interface OMNBankCardInfo (omn_mailRuBankCardInfo)

- (OMNMailRuCardInfo *)omn_mailRuCardInfo;

@end

@implementation OMNMailRuBankCardMediator {
  
  dispatch_block_t _didPayBlock;
  dispatch_block_t _didCloseBlock;
  
}

- (void)registerCard {
  
  OMNAddBankPurpose purpose = kAddBankPurposeRegister;
  if (self.order != nil) {
    
    purpose |= kAddBankPurposePayment;
    
  }

  [self addCardWithPurpose:purpose];
  
}

- (void)addCardForPayment {
  
  [self addCardWithPurpose:kAddBankPurposePayment];
  
}

- (void)addCardWithPurpose:(OMNAddBankPurpose)addBankPurpose {
  
  OMNAddBankCardVC *addBankCardVC = [[OMNAddBankCardVC alloc] init];
  addBankCardVC.purpose = addBankPurpose;
  __weak typeof(self)weakSelf = self;
  __weak UIViewController *rootVC = self.rootVC;
  
  [addBankCardVC setAddCardBlock:^(OMNBankCardInfo *bankCardInfo) {
    
    if (bankCardInfo.saveCard) {
      
      [weakSelf confirmCard:bankCardInfo];
      
    }
    else {
      
      [weakSelf payWithCardInfo:bankCardInfo];
      
    }
    
  }];
  
  [addBankCardVC setCancelBlock:^{
    
    [rootVC.navigationController popToViewController:rootVC animated:YES];
    
  }];
  
  [rootVC.navigationController pushViewController:addBankCardVC animated:YES];
  
}

- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo {

  OMNMailRUCardConfirmVC *mailRUCardConfirmVC = [[OMNMailRUCardConfirmVC alloc] initWithCardInfo:bankCardInfo];
  __weak UIViewController *rootVC = self.rootVC;
  mailRUCardConfirmVC.didFinishBlock = ^{
    
    [rootVC.navigationController popToViewController:rootVC animated:YES];
    
  };
  
  long long enteredAmountWithTips = self.order.enteredAmountWithTips;
  __weak typeof(self)weakSelf = self;
  mailRUCardConfirmVC.noSMSBlock = ^{
    
    OMNPaymentAlertVC *paymentAlertVC = [[OMNPaymentAlertVC alloc] initWithAmount:enteredAmountWithTips];
    [rootVC.navigationController presentViewController:paymentAlertVC animated:YES completion:nil];
    
    paymentAlertVC.didCloseBlock = ^{
      
      [rootVC.navigationController dismissViewControllerAnimated:YES completion:nil];
      
    };
    
    paymentAlertVC.didPayBlock = ^{
      
      [rootVC.navigationController dismissViewControllerAnimated:YES completion:nil];
      bankCardInfo.card_id = nil;
      bankCardInfo.saveCard =  NO;
      [weakSelf payWithCardInfo:bankCardInfo];
      
    };
    
  };
  
  [rootVC.navigationController pushViewController:mailRUCardConfirmVC animated:YES];
  
}

- (void)payWithCardInfo:(OMNBankCardInfo *)bankCardInfo {

  if (nil == bankCardInfo ||
      !bankCardInfo.readyForPayment) {
    
    [self addCardForPayment];
    
    return;
  }
  
  OMNOrder *order = self.order;
  [self showPaymentVCWithDidPresentBlock:^(OMNPaymentDidFinishBlock paymentDidFinishBlock) {
    
    OMNMailRuCardInfo *mailRuCardInfo = [bankCardInfo omn_mailRuCardInfo];
    OMNOrderTansactionInfo *orderTansactionInfo = [[OMNOrderTansactionInfo alloc] initWithOrder:order];
    
    [order getPaymentInfoForUser:[OMNAuthorization authorisation].user cardInfo:mailRuCardInfo copmletion:^(OMNMailRuPaymentInfo *paymentInfo) {
      
      [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
        
        [bankCardInfo logCardRegister];
        [[OMNOperationManager sharedManager] POST:@"/report/mail/payment" parameters:response success:nil failure:nil];
        [[OMNAnalitics analitics] logPayment:orderTansactionInfo cardInfo:bankCardInfo bill_id:order.bill.id];
        paymentDidFinishBlock(nil);
        
      } failure:^(NSError *mailError, NSDictionary *request, NSDictionary *response) {
        
        [[OMNAnalitics analitics] logMailEvent:@"ERROR_MAIL_CARD_PAY" cardInfo:bankCardInfo error:mailError request:request response:response];
        OMNError *omnomError = [OMNError omnnomErrorFromError:mailError];
        paymentDidFinishBlock(omnomError);
        
      }];
      
    } failure:^(OMNError *error) {
      
      paymentDidFinishBlock(error);
      
    }];
    
  }];
  
}

@end

@implementation OMNBankCardInfo (omn_mailRuBankCardInfo)

- (OMNMailRuCardInfo *)omn_mailRuCardInfo {
  
  OMNMailRuCardInfo *mailRuCardInfo = nil;
  if (self.card_id) {
    
    mailRuCardInfo = [OMNMailRuCardInfo cardInfoWithCardId:self.card_id];
    
  }
  else if (self.expiryMonth &&
           self.expiryYear &&
           self.cvv &&
           self.pan){
    
    NSString *exp_date = [OMNMailRuCardInfo exp_dateFromMonth:self.expiryMonth year:self.expiryYear];
    mailRuCardInfo = [OMNMailRuCardInfo cardInfoWithCardPan:self.pan exp_date:exp_date cvv:self.cvv];
    
  }
  
  return mailRuCardInfo;
  
}

@end
