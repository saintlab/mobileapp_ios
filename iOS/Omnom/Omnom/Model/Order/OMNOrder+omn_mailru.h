//
//  OMNOrder+omn_mailru.h
//  omnom
//
//  Created by tea on 22.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

@class OMNUser;
@class OMNMailRuCardInfo;
@class OMNMailRuPaymentInfo;

typedef void(^OMNMailRuPaymentInfoBlock)(OMNMailRuPaymentInfo *paymentInfo);

@interface OMNOrder (omn_mailru)

- (void)getPaymentInfoForUser:(OMNUser *)user cardInfo:(OMNMailRuCardInfo *)cardInfo copmletion:(OMNMailRuPaymentInfoBlock)completionBlock failure:(void (^)(NSError *error))failureBlock;

@end
