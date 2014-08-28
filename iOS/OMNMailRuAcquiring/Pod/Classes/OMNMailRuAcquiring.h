//
//  OMNMailRuAcquiring.h
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import <AFNetworking.h>
#import "OMNMailRuPaymentInfo.h"

@interface OMNMailRuAcquiring : AFHTTPRequestOperationManager

+ (instancetype)acquiring;

- (NSData *)certificateData;

- (void)registerCard:(NSDictionary *)cardInfo user_login:(NSString *)user_login user_phone:(NSString *)user_phone completion:(void(^)(id response))completion;

- (void)cardVerify:(double)amount user_login:(NSString *)user_login card_id:(NSString *)card_id completion:(void(^)(id response))completion;

- (void)payWithInfo:(OMNMailRuPaymentInfo *)paymentInfo completion:(void(^)(id response))completionBlock;

- (void)cardDelete:(NSString *)card_id user_login:(NSString *)user_login completion:(void(^)(id response))completionBlock;

@end
