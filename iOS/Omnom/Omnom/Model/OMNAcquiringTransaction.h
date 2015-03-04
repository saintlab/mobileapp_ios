//
//  OMNAcquiringTransaction.h
//  omnom
//
//  Created by tea on 04.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNError.h"
#import "OMNBankCardInfo.h"
#import "OMNOrder.h"

typedef void(^OMNPaymentInfoBlock)(id paymentInfo);

@interface OMNAcquiringTransaction : NSObject

@property (nonatomic, assign) long long enteredAmount;
@property (nonatomic, assign) long long tipAmount;
@property (nonatomic, assign, readonly) long long totalAmount;

@property (nonatomic, copy) NSString *restaurant_id;
@property (nonatomic, copy) NSString *restaurateur_order_id;
@property (nonatomic, copy) NSString *table_id;

- (instancetype)initWithOrder:(OMNOrder *)order;
- (void)payWithCard:(OMNBankCardInfo *)bankCardInfo completion:(dispatch_block_t)completionBlock failure:(void (^)(OMNError *))failureBlock;

@end
