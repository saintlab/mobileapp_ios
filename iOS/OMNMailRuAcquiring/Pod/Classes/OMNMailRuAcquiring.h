//
//  OMNMailRuAcquiring.h
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import <PromiseKit.h>
#import <AFNetworking.h>
#import "OMNMailRuError.h"
#import "OMNMailRuTransaction.h"
#import "OMNMailRuPoll.h"

@interface OMNMailRuAcquiring : AFHTTPRequestOperationManager

+ (instancetype)acquiring;
+ (OMNMailRuConfig *)config;
+ (void)setConfig:(NSDictionary *)config;

+ (PMKPromise *)registerCardWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv user:(OMNMailRuUser *)user;
+ (PMKPromise *)registerCard:(OMNMailRuCard *)card user:(OMNMailRuUser *)user;
+ (PMKPromise *)verifyCardWithID:(NSString *)cardID user:(OMNMailRuUser *)user amount:(NSNumber *)amount;
+ (PMKPromise *)payAndRegisterWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv user:(OMNMailRuUser *)user;

+ (PMKPromise *)payWithWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv user:(OMNMailRuUser *)user order_id:(NSString *)order_id order_amount:(NSNumber *)order_amount extra:(OMNMailRuExtra *)extra;
+ (PMKPromise *)payWithCardID:(NSString *)cardID user:(OMNMailRuUser *)user order_id:(NSString *)order_id order_amount:(NSNumber *)order_amount extra:(OMNMailRuExtra *)extra;
+ (PMKPromise *)payWithCard:(OMNMailRuCard *)card user:(OMNMailRuUser *)user order_id:(NSString *)order_id order_amount:(NSNumber *)order_amount extra:(OMNMailRuExtra *)extra;

+ (PMKPromise *)refundOrder:(NSString *)orderID;

//+ (PMKPromise *)deleteCardWithID:(NSString *)cardID user:(OMNMailRuUser *)user;

@end

