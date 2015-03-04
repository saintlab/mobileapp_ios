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

typedef void(^OMNPaymentInfoBlock)(id paymentInfo);

@interface OMNAcquiringTransaction : NSObject

- (void)createPaymentInfoWithCard:(OMNBankCardInfo *)bankCardInfo completion:(OMNPaymentInfoBlock)completionBlock failure:(void (^)(OMNError *error))failureBlock;

@end
