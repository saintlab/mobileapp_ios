//
//  OMNBankCardMediator.h
//  omnom
//
//  Created by tea on 19.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"
#import "OMNBankCardInfo.h"

typedef void(^OMNBankCardInfoBlock)(OMNBankCardInfo *bankCardInfo);
typedef void(^OMNPaymentFinishBlock)(NSError *error, dispatch_block_t completionBlock);
typedef void(^OMNPaymentPresentBlock)(OMNPaymentFinishBlock paymentFinishBlock);

@interface OMNBankCardMediator : NSObject

@property (nonatomic, strong, readonly) UIViewController *rootVC;

- (instancetype)initWithRootVC:(UIViewController *)vc;

- (void)addCardForOrder:(OMNOrder *)order requestPaymentWithCard:(OMNBankCardInfoBlock)requestPaymentWithCardBlock;
- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo;

- (void)beginPaymentProcessWithPresentBlock:(OMNPaymentPresentBlock)presentBlock;

@end
