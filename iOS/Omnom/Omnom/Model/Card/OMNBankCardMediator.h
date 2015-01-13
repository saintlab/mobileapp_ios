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

@property (nonatomic, weak, readonly) UIViewController *rootVC;
@property (nonatomic, strong, readonly) OMNOrder *order;

@property (nonatomic, copy) dispatch_block_t didPayBlock;
@property (nonatomic, copy) dispatch_block_t didFailPayBlock;

- (instancetype)initWithOrder:(OMNOrder *)order rootVC:(__weak UIViewController *)rootVC;

- (void)addCard;
- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo;

- (void)payWithCardInfo:(OMNBankCardInfo *)bankCardInfo completion:(dispatch_block_t)completionBlock failure:(void (^)(NSError *, NSDictionary *))failureBlock;
- (void)beginPaymentProcessWithPresentBlock:(OMNPaymentPresentBlock)presentBlock;

@end
