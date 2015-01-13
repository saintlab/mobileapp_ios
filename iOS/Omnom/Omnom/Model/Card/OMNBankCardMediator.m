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

@implementation OMNBankCardMediator {
  
}

- (instancetype)initWithOrder:(OMNOrder *)order rootVC:(__weak UIViewController *)rootVC {
  self = [super init];
  if (self) {
    
    _rootVC = rootVC;
    _order = order;
    
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
  __weak typeof(self)weakSelf = self;
  [_rootVC.navigationController omn_pushViewController:paymentLoadingVC animated:YES completion:^{
    
    [paymentLoadingVC startLoading];
    paymentVCDidPresentBlock(^(OMNError *error) {
      
      if (error) {
        
        [paymentLoadingVC didFailWithError:error action:^{
          
          weakSelf.didPayBlock(error);
          
        }];
        
      }
      else {
        
        [paymentLoadingVC finishLoading:^{
          
          weakSelf.didPayBlock(error);
          
        }];
        
      }
      
    });
    
  }];
  
}

@end
