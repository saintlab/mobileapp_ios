//
//  OMNTestBankCardsModel.m
//  omnom
//
//  Created by tea on 18.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTestBankCardsModel.h"
#import "OMNBankCard.h"

@implementation OMNTestBankCardsModel

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock {
  
  OMNBankCard *bankCard = [[OMNBankCard alloc] init];
  bankCard.id = @"1";
  bankCard.demo = YES;
  bankCard.association = @"visa";
  bankCard.masked_pan = @"4111 .... .... 1111";
  bankCard.issuer = @"JPMORGAN CHASE BANK, N.A.";
  bankCard.status = kOMNBankCardStatusRegistered;
  self.cards = [NSMutableArray arrayWithObject:bankCard];
  [self updateCardSelection];
  completionBlock();
  
}

@end
