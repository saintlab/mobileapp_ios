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

- (void)logCardRegister {
  NSMutableDictionary *parametrs = [NSMutableDictionary dictionary];
  parametrs[@"scanner_used"] = @(self.scanUsed);
  if (self.card_id) {
    parametrs[@"card_id"] = self.card_id;
  }
  parametrs[@"number_of_register_attempts"] = @(self.numberOfRegisterAttempts);
  [[OMNAnalitics analitics] logTargetEvent:@"card_added" parametrs:parametrs];
}

@end
