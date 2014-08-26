//
//  OMNMailRuBankCardsModel.m
//  omnom
//
//  Created by tea on 19.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRuBankCardsModel.h"
#import <SSKeychain.h>

NSString * const kAccountName = @"mail.ru";
NSString * const kCardIdServiceName = @"card_id";

@implementation OMNMailRuBankCardsModel {
}

@synthesize cards=_cards;

- (NSString *)card_id {
  return [SSKeychain passwordForService:kCardIdServiceName account:kAccountName];
}

- (void)setCard_id:(NSString *)card_id {
  if (nil == card_id) {
    [SSKeychain deletePasswordForService:kCardIdServiceName account:kAccountName];
  }
  else {
    [SSKeychain setPassword:card_id forService:kCardIdServiceName account:kAccountName];
  }
}

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock {
  
  __weak typeof(self)weakSelf = self;
  [OMNBankCard getCardsWithCompletion:^(NSArray *cards) {
    
    [weakSelf didLoadCards:cards];
    completionBlock();
    
  } failure:^(NSError *error) {
    
    completionBlock();
    
  }];
  
}

- (void)didLoadCards:(NSArray *)cards {
  
  _cards = [cards mutableCopy];
  
  if (nil == self.card_id) {
    
    [self updateCardSelection];
    
  }
  else {
    
    __block OMNBankCard *selectedCard = nil;
    NSString *card_id = self.card_id;
    [_cards enumerateObjectsUsingBlock:^(OMNBankCard *bankCard, NSUInteger idx, BOOL *stop) {
      if ([bankCard.id isEqualToString:card_id]) {
        selectedCard = bankCard;
        *stop = YES;
      }
    }];
    
    if (selectedCard) {
      self.selectedCard = selectedCard;
    }
    else {
      [self updateCardSelection];
    }
    
  }
  
}

@end
