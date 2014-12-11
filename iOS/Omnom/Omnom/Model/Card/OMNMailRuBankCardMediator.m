//
//  OMNMailRuBankCardMediator.m
//  omnom
//
//  Created by tea on 19.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRuBankCardMediator.h"
#import "OMNAddBankCardVC.h"
#import "OMNMailRUCardConfirmVC.h"
#import "OMNPaymentAlertVC.h"
#import "OMNOrder.h"
#import "OMNBankCardInfo.h"
#import "UINavigationController+omn_replace.h"
#import "OMNLoadingCircleVC.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import <OMNMailRuPaymentInfo.h>
#import "OMNOrder+omn_mailru.h"
#import <OMNMailRuAcquiring.h>
#import "OMNOperationManager.h"
#import "OMNAnalitics.h"
#import "OMNUtils.h"
#import "OMNOrderTansactionInfo.h"

@implementation OMNMailRuBankCardMediator {
  
  OMNOrder *_order;
  OMNBankCardInfoBlock _requestPaymentWithCardBlock;

  dispatch_block_t _didPayBlock;
  dispatch_block_t _didCloseBlock;
  OMNBill *_bill;
  OMNOrderTansactionInfo *_orderTansactionInfo;
}

- (void)addCardForOrder:(OMNOrder *)order requestPaymentWithCard:(OMNBankCardInfoBlock)requestPaymentWithCardBlock {
  
  _order = order;
  _requestPaymentWithCardBlock = [requestPaymentWithCardBlock copy];
  
  OMNAddBankCardVC *addBankCardVC = [[OMNAddBankCardVC alloc] init];
  addBankCardVC.hideSaveButton = (order == nil);
  __weak typeof(self)weakSelf = self;
  __weak UIViewController *rootVC = self.rootVC;
  
  [addBankCardVC setAddCardBlock:^(OMNBankCardInfo *bankCardInfo) {
    
    if (bankCardInfo.saveCard) {
      
      [weakSelf confirmCard:bankCardInfo];
      
    }
    else {
      
      [weakSelf requestPaymentWithCard:bankCardInfo];
      
    }
    
  }];
  
  [addBankCardVC setCancelBlock:^{
    
    [rootVC.navigationController popToViewController:rootVC animated:YES];
    
  }];
  
  [rootVC.navigationController pushViewController:addBankCardVC animated:YES];
  
}

- (void)requestPaymentWithCard:(OMNBankCardInfo *)bankCardInfo {
  
  if (_requestPaymentWithCardBlock) {
    _requestPaymentWithCardBlock(bankCardInfo);
  }
  
}

- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo {

  OMNMailRUCardConfirmVC *mailRUCardConfirmVC = [[OMNMailRUCardConfirmVC alloc] initWithCardInfo:bankCardInfo];
  __weak UIViewController *rootVC = self.rootVC;
  mailRUCardConfirmVC.didFinishBlock = ^{
    
    [rootVC.navigationController popToViewController:rootVC animated:YES];
    
  };
  
  long long enteredAmountWithTips = _order.enteredAmountWithTips;
  NSString *alertText = NSLocalizedString(@"NO_SMS_ALERT_TEXT", @"Вероятно, SMS-уведомления не подключены. Нужно посмотреть последнее списание в банковской выписке и узнать сумму.");
  NSString *alertConfirmText = (_order) ? (NSLocalizedString(@"NO_SMS_ALERT_ACTION_TEXT", @"Если посмотреть сумму списания сейчас возможности нет, вы можете однократно оплатить сумму без привязки карты.")) : (nil);
  
  __weak typeof(self)weakSelf = self;
  mailRUCardConfirmVC.noSMSBlock = ^{
    
    OMNPaymentAlertVC *paymentAlertVC = [[OMNPaymentAlertVC alloc] initWithText:alertText detailedText:alertConfirmText amount:enteredAmountWithTips];
    [rootVC.navigationController presentViewController:paymentAlertVC animated:YES completion:nil];
    
    paymentAlertVC.didCloseBlock = ^{
      
      [rootVC.navigationController dismissViewControllerAnimated:YES completion:nil];
      
    };
    
    paymentAlertVC.didPayBlock = ^{
      
      [rootVC.navigationController dismissViewControllerAnimated:YES completion:nil];
      [weakSelf requestPaymentWithCard:bankCardInfo];
      
    };
    
  };
  
  [rootVC.navigationController pushViewController:mailRUCardConfirmVC animated:YES];
  
}

@end
