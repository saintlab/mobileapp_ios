//
//  OMNBankCard.h
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OMNBankCardStatus) {
  kOMNBankCardStatusUnknown = 0,
  kOMNBankCardStatusHeld,
  kOMNBankCardStatusRegistered,
};

@interface OMNBankCard : NSObject
<NSCoding>

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *association;
@property(nonatomic, copy) NSString *confirmed_by;
@property(nonatomic, copy) NSString *created_at;
@property(nonatomic, copy) NSString *external_card_id;
@property(nonatomic, copy) NSString *masked_pan;
@property(nonatomic, assign) OMNBankCardStatus status;
@property(nonatomic, copy) NSString *updated_at;
@property(nonatomic, copy) NSString *user_id;

@property(nonatomic, assign, readonly) BOOL deleting;

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

- (instancetype)initWithJsonData:(id)jsonData;

+ (void)getCardsWithCompletion:(void(^)(NSArray *cards))completionBlock failure:(void(^)(NSError *error))failureBlock;
- (void)deleteWithCompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock;

@end

@interface NSDictionary (omn_decodeCardData)

- (void)decodeCardData:(void(^)(NSArray *))completionBlock failure:(void(^)(NSError *))failureBlock;

@end


