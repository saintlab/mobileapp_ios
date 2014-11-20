//
//  OMNMailRuAcquiring.h
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import <AFNetworking.h>
#import "OMNMailRuPaymentInfo.h"

typedef NS_ENUM(NSUInteger, OMNMailRuErrorCode) {
  kOMNMailRuErrorCodeUnknown = 0,
  kOMNMailRuErrorCodeCardAmount,
};

@interface OMNMailRuAcquiring : AFHTTPRequestOperationManager

+ (instancetype)acquiring;
+ (NSDictionary *)config;
+ (BOOL)isValidConfig:(NSDictionary *)config;
+ (void)setConfig:(NSDictionary *)config;
- (NSString *)testCVV;

- (void)registerCard:(NSDictionary *)cardInfo user_login:(NSString *)user_login user_phone:(NSString *)user_phone completion:(void(^)(id response, NSString *cardId))completion;

- (void)cardVerify:(double)amount user_login:(NSString *)user_login card_id:(NSString *)card_id completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error, NSDictionary *debugInfo))failureBlock;

- (void)payWithInfo:(OMNMailRuPaymentInfo *)paymentInfo completion:(void(^)(id response))completionBlock failure:(void(^)(NSError *error, NSDictionary *debugInfo))failureBlock;

- (void)cardDelete:(NSString *)card_id user_login:(NSString *)user_login completion:(void(^)(id response))completionBlock;

@end
