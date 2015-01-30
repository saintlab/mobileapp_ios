//
//  OMNBankCard+omn_info.m
//  omnom
//
//  Created by tea on 11.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBankCard+omn_info.h"

@implementation OMNBankCard (omn_info)

- (OMNBankCardInfo *)bankCardInfo {
  
  OMNBankCardInfo *bankCardInfo = [[OMNBankCardInfo alloc] init];
  bankCardInfo.card_id = self.external_card_id;
  bankCardInfo.masked_pan = (self.masked_pan_6_4) ? (self.masked_pan_6_4) : (self.masked_pan);
  return bankCardInfo;
  
}

@end
