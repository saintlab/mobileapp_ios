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
#import "OMNMailRUCardConfirmVC.h"
#import "OMNAnalitics.h"
#import <OMNMailRuAcquiring.h>
#import "OMNAuthorization.h"
#import "OMNMailRuBankCardsModel.h"
#import "OMNBankCard+omn_info.h"

@implementation OMNMailRuBankCardMediator

- (void)registerCard {
  
  OMNAddBankPurpose purpose = kAddBankPurposeRegister;
  if (self.acquiringTransaction) {
    
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
  
  @weakify(self)
  [addBankCardVC setAddCardBlock:^(OMNBankCardInfo *bankCardInfo) {
    
    @strongify(self)
    if (bankCardInfo.saveCard) {
      
      [self confirmCard:bankCardInfo];
      
    }
    else {
      
      [self payWithCardInfo:bankCardInfo];
      
    }
    
  }];
  
  [addBankCardVC setCancelBlock:^{
    
    @strongify(self)
    [self.rootVC.navigationController popToViewController:self.rootVC animated:YES];
    
  }];
  
  [self.rootVC.navigationController pushViewController:addBankCardVC animated:YES];
  
}

- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo {

  OMNMailRUCardConfirmVC *mailRUCardConfirmVC = [[OMNMailRUCardConfirmVC alloc] initWithCardInfo:bankCardInfo];
  @weakify(self)
  mailRUCardConfirmVC.didFinishBlock = ^{
    
    @strongify(self)
    [self.rootVC.navigationController popToViewController:self.rootVC animated:YES];
    
  };
  
  long long enteredAmountWithTips = self.acquiringTransaction.total_amount;
  mailRUCardConfirmVC.noSMSBlock = ^{
    
    @strongify(self)
    OMNPaymentAlertVC *paymentAlertVC = [[OMNPaymentAlertVC alloc] initWithAmount:enteredAmountWithTips];
    [self.rootVC.navigationController presentViewController:paymentAlertVC animated:YES completion:nil];
    
    paymentAlertVC.didCloseBlock = ^{
      
      [self.rootVC.navigationController dismissViewControllerAnimated:YES completion:nil];
      
    };
    
    paymentAlertVC.didPayBlock = ^{
      
      [self.rootVC.navigationController dismissViewControllerAnimated:YES completion:nil];
      bankCardInfo.card_id = nil;
      bankCardInfo.saveCard =  NO;
      [self payWithCardInfo:bankCardInfo];
      
    };
    
  };
  
  [self.rootVC.navigationController pushViewController:mailRUCardConfirmVC animated:YES];
  
}

- (void)payWithCardInfo:(OMNBankCardInfo *)bankCardInfo {

  if (nil == bankCardInfo ||
      !bankCardInfo.readyForPayment) {
    
    [self addCardForPayment];
    return;
    
  }
  
  @weakify(self)
  [self showPaymentVCWithDidPresentBlock:^(OMNPaymentDidFinishBlock paymentDidFinishBlock) {
  
    @strongify(self)
    [self.acquiringTransaction payWithCard:bankCardInfo completion:paymentDidFinishBlock];
    
  }];
  
}

- (OMNBankCardsModel *)bankCardsModel {
  
  OMNBankCardsModel *bankCardsModel = [[OMNMailRuBankCardsModel alloc] init];
  @weakify(self)
  [bankCardsModel setDidSelectCardBlock:^(OMNBankCard *bankCard) {
    
    if (kOMNBankCardStatusHeld == bankCard.status) {
      
      @strongify(self)
      [self confirmCard:[bankCard bankCardInfo]];
      
    }
    
  }];
  
  return bankCardsModel;
  
}

@end
