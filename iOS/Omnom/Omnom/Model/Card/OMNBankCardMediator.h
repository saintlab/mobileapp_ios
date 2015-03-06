//
//  OMNBankCardMediator.h
//  omnom
//
//  Created by tea on 19.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAcquiringTransaction.h"
#import "OMNBankCardInfo.h"
#import "OMNError.h"
#import "OMNBankCardsModel.h"

typedef void(^OMNPaymentVCDidPresentBlock)(OMNPaymentDidFinishBlock paymentDidFinishBlock);

@interface OMNBankCardMediator : NSObject

@property (nonatomic, weak, readonly) UIViewController *rootVC;
@property (nonatomic, strong, readonly) OMNAcquiringTransaction *acquiringTransaction;
@property (nonatomic, copy) OMNPaymentDidFinishBlock didPayBlock;

- (instancetype)initWithRootVC:(UIViewController *)rootVC transaction:(OMNAcquiringTransaction *)transaction;

- (void)addCardForPayment;
- (void)registerCard;
- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo;

- (void)payWithCardInfo:(OMNBankCardInfo *)bankCardInfo;
- (void)showPaymentVCWithDidPresentBlock:(OMNPaymentVCDidPresentBlock)paymentVCDidPresentBlock;

- (OMNBankCardsModel *)bankCardsModel;

@end
