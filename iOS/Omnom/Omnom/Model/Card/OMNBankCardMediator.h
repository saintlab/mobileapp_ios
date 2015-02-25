//
//  OMNBankCardMediator.h
//  omnom
//
//  Created by tea on 19.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"
#import "OMNBankCardInfo.h"
#import "OMNError.h"

typedef void(^OMNPaymentDidFinishBlock)(OMNError *error);
typedef void(^OMNPaymentVCDidPresentBlock)(OMNPaymentDidFinishBlock paymentDidFinishBlock);

@interface OMNBankCardMediator : NSObject

@property (nonatomic, weak, readonly) UIViewController *rootVC;
@property (nonatomic, strong, readonly) OMNOrder *order;

@property (nonatomic, copy) OMNPaymentDidFinishBlock didPayBlock;

- (instancetype)initWithOrder:(OMNOrder *)order rootVC:(__weak UIViewController *)rootVC;

- (void)addCardForPayment;
- (void)registerCard;
- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo;

- (void)payWithCardInfo:(OMNBankCardInfo *)bankCardInfo;
- (void)showPaymentVCWithDidPresentBlock:(OMNPaymentVCDidPresentBlock)paymentVCDidPresentBlock;

@end
