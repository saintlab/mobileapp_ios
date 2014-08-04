//
//  OMNMailRuAcquiring.h
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import <AFNetworking.h>

@interface OMNMailRuAcquiring : AFHTTPRequestOperationManager

+ (instancetype)acquiring;

- (void)registerCard:(NSDictionary *)cardInfo completion:(void(^)(id response))completion;

- (void)cardVerify:(double)amount card_id:(NSString *)card_id;

- (void)payWithCardInfo:(NSDictionary *)cardInfo addCard:(BOOL)addCard;

- (void)cardDelete:(NSString *)card_id;

@end
