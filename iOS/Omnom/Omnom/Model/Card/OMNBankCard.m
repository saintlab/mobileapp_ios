//
//  OMNBankCard.m
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCard.h"

@implementation OMNBankCard

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.id = [jsonData[@"id"] description];
    self.association = jsonData[@"association"];
    self.confirmed_by = jsonData[@"confirmed_by"];
    self.created_at = jsonData[@"created_at"];
    self.external_card_id = jsonData[@"external_card_id"];
    self.masked_pan = ([jsonData[@"masked_pan"] isKindOfClass:[NSString class]]) ? (jsonData[@"masked_pan"]) : (@"");
    self.masked_pan_6_4 = ([jsonData[@"masked_pan_6_4"] isKindOfClass:[NSString class]]) ? (jsonData[@"masked_pan_6_4"]) : (@"");
    self.status = [self statusFromString:jsonData[@"status"]];
    self.updated_at = jsonData[@"updated_at"];
    self.user_id = jsonData[@"user_id"];
    if ([jsonData[@"issuer"] isKindOfClass:[NSString class]]) {
      self.issuer = jsonData[@"issuer"];
    }
    
  }
  return self;
}

- (OMNBankCardStatus)statusFromString:(NSString *)string {
  
  OMNBankCardStatus status = kOMNBankCardStatusUnknown;
  
  if (![string isKindOfClass:[NSString class]]) {
    //do nothing
  }
  else if ([string isEqualToString:@"registered"]) {
    status = kOMNBankCardStatusRegistered;
  }
  else if ([string isEqualToString:@"held"]) {
    status = kOMNBankCardStatusHeld;
  }
  return status;
  
}

@end