//
//  OMNBankCardInfo+omn_mailRuBankCardInfo.m
//  omnom
//
//  Created by tea on 16.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBankCardInfo+omn_mailRuBankCardInfo.h"

@implementation OMNBankCardInfo (omn_mailRuBankCardInfo)

- (OMNMailRuCard *)omn_mailRuCardInfo {
  
  OMNMailRuCard *mailRuCardInfo = nil;
  if (self.card_id) {
    
    mailRuCardInfo = [OMNMailRuCard cardWithID:self.card_id];
    
  }
  else if (self.cvv &&
           self.pan){
    
    NSString *exp_date = [OMNMailRuCard exp_dateFromMonth:self.expiryMonth year:self.expiryYear];
    mailRuCardInfo = [OMNMailRuCard cardWithPan:self.pan exp_date:exp_date cvv:self.cvv];
    
  }
  
  return mailRuCardInfo;
  
}

@end