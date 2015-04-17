//
//  OMNMailRuAcquiring.h
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import <AFNetworking.h>
#import "OMNMailRuTransaction.h"
#import <PromiseKit.h>

extern NSString *const OMNMailRuErrorDomain;

typedef NS_ENUM(NSInteger, OMNMailRuErrorCode) {
  
  kOMNMailRuErrorCodeUnknown = -1,
  kOMNMailRuErrorCodeDefault = 0,
  kOMNMailRuErrorCodeCardAmount,
  
};

@interface OMNMailRuAcquiring : AFHTTPRequestOperationManager

+ (instancetype)acquiring;
+ (OMNMailRuConfig *)config;
+ (void)setConfig:(NSDictionary *)config;

+ (PMKPromise *)registerCard:(OMNMailRuTransaction *)transaction;
+ (PMKPromise *)verifyCard:(OMNMailRuTransaction *)transaction;
+ (PMKPromise *)deleteCard:(OMNMailRuTransaction *)transaction;

+ (PMKPromise *)payWithInfo:(OMNMailRuTransaction *)paymentInfo;
+ (PMKPromise *)refundOrder:(NSString *)orderID;


@end

@interface NSError (mailRuError)

+ (NSError *)omn_errorFromRequest:(id)request response:(id)response;

@end

