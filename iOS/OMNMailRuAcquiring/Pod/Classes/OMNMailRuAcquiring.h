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

- (void)registerCard:(NSString *)pan expDate:(NSString *)expDate cvv:(NSString *)cvv;

- (void)cardVerify:(double)amount card_id:(NSString *)card_id;

- (void)payWithCardInfo:(NSDictionary *)cardInfo addCard:(BOOL)addCard;

@end
