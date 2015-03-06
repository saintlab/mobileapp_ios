//
//  OMNBankCardMediator.m
//  omnom
//
//  Created by tea on 19.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardMediator.h"
#import "OMNPaymentLoadingVC.h"
#import "UINavigationController+omn_replace.h"
#import "OMNMailAcquiringTransaction.h"

@implementation OMNBankCardMediator

- (instancetype)initWithRootVC:(UIViewController *)rootVC transaction:(OMNAcquiringTransaction *)transaction {
  self = [super init];
  if (self) {
    
    _rootVC = rootVC;
    _acquiringTransaction = transaction;
    
  }
  return self;
}

- (void)addCardForPayment {
  //do nothing
}

- (void)registerCard {
  //do nothing
}

- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo {
  //do nothing
}

- (void)payWithCardInfo:(OMNBankCardInfo *)bankCardInfo {
  //do nothing
}

- (void)showPaymentVCWithDidPresentBlock:(OMNPaymentVCDidPresentBlock)paymentVCDidPresentBlock {
  
  OMNPaymentLoadingVC *paymentLoadingVC = [[OMNPaymentLoadingVC alloc] init];
  @weakify(self)
  [_rootVC.navigationController omn_pushViewController:paymentLoadingVC animated:YES completion:^{
    
    [paymentLoadingVC startLoading];
    paymentVCDidPresentBlock(^(OMNBill *bill, OMNError *error) {
      
      @strongify(self)
      if (error) {
        
        [paymentLoadingVC didFailWithError:error action:^{
          
          self.didPayBlock(bill, error);
          
        }];
        
      }
      else {
        
        [paymentLoadingVC finishLoading:^{
          
          self.didPayBlock(bill, error);
          
        }];
        
      }
      
    });
    
  }];
  
}

- (OMNBankCardsModel *)bankCardsModel {
  
  return nil;
  
}

@end
