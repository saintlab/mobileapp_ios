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

@interface OMNMailRuAcquiring : AFHTTPRequestOperationManager

+ (instancetype)acquiring;
+ (OMNMailRuConfig *)config;
+ (void)setConfig:(NSDictionary *)config;

+ (PMKPromise *)registerCard:(OMNMailRuTransaction *)transaction;
+ (PMKPromise *)verifyCard:(OMNMailRuTransaction *)transaction;
+ (PMKPromise *)deleteCard:(OMNMailRuTransaction *)transaction;

+ (PMKPromise *)pay:(OMNMailRuTransaction *)transaction;
+ (PMKPromise *)refundOrder:(NSString *)orderID;

@end

