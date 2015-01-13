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

- (void)addCard {
  //do nothing
}

- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo {
  //do nothing
}

- (void)payWithCardInfo:(OMNBankCardInfo *)bankCardInfo completion:(dispatch_block_t)completionBlock failure:(void (^)(NSError *, NSDictionary *))failureBlock {
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
