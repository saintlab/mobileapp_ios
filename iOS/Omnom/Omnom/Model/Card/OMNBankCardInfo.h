//
//  OMNBankCardInfo.h
//  omnom
//
//  Created by tea on 12.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNBankCardInfo : NSObject
<NSCopying>
@property (nonatomic, copy) NSString *pan;
@property (nonatomic, copy) NSString *masked_pan;
@property (nonatomic, assign) NSInteger expiryMonth;
@property (nonatomic, assign) NSInteger expiryYear;
@property (nonatomic, copy) NSString *cvv;
@property (nonatomic, copy) NSString *card_id;
@property (nonatomic, assign) BOOL saveCard;

@property (nonatomic, assign) BOOL scanUsed;
@property (nonatomic, assign) NSInteger numberOfRegisterAttempts;

- (BOOL)readyForPayment;
- (BOOL)hasPANMMYYCVV;
- (void)logCardRegister;
- (NSDictionary *)debugInfo;

@end
