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

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *association;
@property(nonatomic, copy) NSString *confirmed_by;
@property(nonatomic, copy) NSString *created_at;
@property(nonatomic, copy) NSString *external_card_id;
@property(nonatomic, copy) NSString *masked_pan;
@property(nonatomic, copy) NSString *masked_pan_6_4;
@property(nonatomic, assign) OMNBankCardStatus status;
@property(nonatomic, copy) NSString *updated_at;
@property(nonatomic, copy) NSString *user_id;
@property(nonatomic, copy) NSString *issuer;

@property(nonatomic, assign) BOOL demo;
@property(nonatomic, assign) BOOL deleting;

- (instancetype)initWithJsonData:(id)jsonData;

@end


