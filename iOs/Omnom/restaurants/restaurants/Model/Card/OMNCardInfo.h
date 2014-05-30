//
//  GCardInfo.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNCardInfo : NSObject
<NSCoding>
/// Card number.
@property(nonatomic, copy, readwrite) NSString *cardNumber;

/// Card number with all but the last four digits obfuscated.
@property(nonatomic, copy, readonly) NSString *redactedCardNumber;

/// January == 1
/// @note expiryMonth & expiryYear may be 0, if expiry information was not requested.
@property(nonatomic, assign, readwrite) NSUInteger expiryMonth;

/// The full four digit year.
/// @note expiryMonth & expiryYear may be 0, if expiry information was not requested.
@property(nonatomic, assign, readwrite) NSUInteger expiryYear;

/// Security code (aka CSC, CVV, CVV2, etc.)
/// @note May be nil, if security code was not requested.
@property(nonatomic, copy, readwrite) NSString *cvv;

- (NSString *)fillFormScript;

@end
