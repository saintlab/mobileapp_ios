//
//  OMNMailRuAcquiring.h
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import <AFNetworking.h>
#import "OMNMailRuPaymentInfo.h"

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

- (void)registerCard:(NSDictionary *)cardInfo user_login:(NSString *)user_login user_phone:(NSString *)user_phone completion:(void(^)(NSString *cardId))completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock;

- (void)verifyCard:(NSString *)card_id user_login:(NSString *)user_login amount:(double)amount completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock;

- (void)payWithInfo:(OMNMailRuPaymentInfo *)paymentInfo completion:(void(^)(id response))completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock;

- (void)refundOrder:(NSString *)orderID completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock;

- (void)deleteCard:(NSString *)card_id user_login:(NSString *)user_login сompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock;

@end

@interface NSError (mailRuError)


+ (NSError *)omn_errorFromRequest:(id)request response:(id)response;

@end

