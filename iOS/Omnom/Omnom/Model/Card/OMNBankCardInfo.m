//
//  OMNBankCardInfo.m
//  omnom
//
//  Created by tea on 12.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardInfo.h"
#import "OMNAnalitics.h"

@implementation OMNBankCardInfo

- (id)copyWithZone:(NSZone *)zone {
  
  OMNBankCardInfo *bankCardInfo = [[[self class] allocWithZone:zone] init];
  bankCardInfo.pan = [self.pan copyWithZone:zone];
  bankCardInfo.masked_pan = [self.masked_pan copyWithZone:zone];
  bankCardInfo.expiryMonth = self.expiryMonth;
  bankCardInfo.expiryYear = self.expiryYear;
  bankCardInfo.cvv = [self.cvv copyWithZone:zone];
  bankCardInfo.card_id = [self.card_id copyWithZone:zone];
  bankCardInfo.saveCard = self.saveCard;
  bankCardInfo.scanUsed = self.scanUsed;
  bankCardInfo.numberOfRegisterAttempts = self.numberOfRegisterAttempts;
  return bankCardInfo;
  
}

- (void)logCardRegister {
  
  NSMutableDictionary *parametrs = [NSMutableDictionary dictionary];
  parametrs[@"scanner_used"] = @(self.scanUsed);
  if (self.card_id) {
    parametrs[@"card_id"] = self.card_id;
  }
  parametrs[@"number_of_register_attempts"] = @(self.numberOfRegisterAttempts);
  [[OMNAnalitics analitics] logTargetEvent:@"card_added" parametrs:parametrs];
  
}

- (NSString *)masked_pan {
  
  NSString *masked_pan = @"";
  
  if (_masked_pan) {
    
    masked_pan = _masked_pan;
    
  }
  else if (self.pan.length >= 16) {
    
    NSString *first = [self.pan substringToIndex:6];
    NSString *last = [self.pan substringFromIndex:self.pan.length - 4];
    masked_pan = [NSString stringWithFormat:@"%@***%@", first, last];

  }
  
  return masked_pan;
  
}

- (NSDictionary *)debugInfo {
  
  NSDictionary *cardInfo =
  @{
    @"masked_pan" : (self.masked_pan) ? (self.masked_pan) : (@""),
    @"card_id" : (self.card_id) ? (self.card_id) : (@""),
    };
  
  return cardInfo;
  
}

- (BOOL)readyForPayment {
  
  BOOL hasPANMMYYCVV = (self.pan.length && self.expiryMonth && self.expiryYear && self.cvv.length);
  BOOL hasCardId = (self.card_id.length > 0);
  return (hasPANMMYYCVV || hasCardId);
  
}

@end
