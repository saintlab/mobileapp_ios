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
#import "OMNWish.h"
#import "OMNBill.h"
#import <PromiseKit.h>

typedef void(^OMNPaymentDidFinishBlock)(OMNBill *bill, OMNError *error);

@interface OMNAcquiringTransaction : NSObject

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *wish_id;
@property (nonatomic, copy) NSString *table_id;
@property (nonatomic, copy) NSString *restaurant_id;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, assign) long long bill_amount;
@property (nonatomic, assign) long long tips_amount;
@property (nonatomic, copy) NSString *tips_way;
@property (nonatomic, copy) NSString *split_way;

@property (nonatomic, strong) NSDictionary *info;

- (instancetype)initWithOrder:(OMNOrder *)order;
- (instancetype)initWithWish:(OMNWish *)wish;
- (long long)total_amount;
- (double)tips_percent;
- (void)payWithCard:(OMNBankCardInfo *)bankCardInfo completion:(OMNPaymentDidFinishBlock)completionBlock;

@end
