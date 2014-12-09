//
//  NSError+omn_mailRu.m
//  omnom
//
//  Created by tea on 09.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "NSError+omn_mailRu.h"
#import <OMNMailRuAcquiring.h>
#import "OMNUtils.h"

@implementation NSError (omn_mailRu)

- (NSError *)omn_mailRuToOmnomError {
  
  NSError *error = nil;
  
  if ([self.domain isEqualToString:OMNMailRuErrorDomain]) {
    
    if (kOMNMailRuErrorCodeCardAmount == self.code) {
      
      error = [NSError errorWithDomain:self.domain code:self.code userInfo:
               @{
                 NSLocalizedDescriptionKey : NSLocalizedString(@"ERROR_MESSAGE_PAYMENT_ERROR", @"Ваш банк отклонил платёж.\nПовторите попытку,\nдобавьте другую карту\nили оплатите наличными."),
                 }];

    }
    else {
    
      error = self;
      
    }
    
  }
  else {
    
    error = [self omn_internetError];
    
  }
  
  return error;
  
}

@end
