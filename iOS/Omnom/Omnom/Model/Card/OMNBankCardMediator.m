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

- (instancetype)initWithRootVC:(UIViewController *)vc {
  self = [super init];
  if (self) {
    _rootVC = vc;
  }
  return self;
}

- (void)addCardForOrder:(OMNOrder *)order requestPaymentWithCard:(OMNBankCardInfoBlock)requestPaymentWithCardBlock {
  //do nothing
}

- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo {
  //do nothing
}

- (void)beginPaymentProcessWithPresentBlock:(OMNPaymentPresentBlock)presentBlock {
  
  OMNPaymentLoadingVC *paymentLoadingVC = [[OMNPaymentLoadingVC alloc] init];
  OMNPaymentFinishBlock paymentFinishBlock = ^(NSError *error, dispatch_block_t completionBlock) {
    
    if (error) {
      
      [paymentLoadingVC didFailWithError:error action:completionBlock];
      
    }
    else {
      
      [paymentLoadingVC finishLoading:completionBlock];
      
    }
    
  };
  
  [_rootVC.navigationController omn_pushViewController:paymentLoadingVC animated:YES completion:^{
    
    [paymentLoadingVC startLoading];
    presentBlock(paymentFinishBlock);
    
  }];
  
}

@end
