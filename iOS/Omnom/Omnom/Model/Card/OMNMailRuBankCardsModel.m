//
//  OMNMailRuBankCardsModel.m
//  omnom
//
//  Created by tea on 19.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRuBankCardsModel.h"
#import <SSKeychain.h>

@implementation OMNMailRuBankCardsModel {
  
}

@synthesize selectedCard=_selectedCard;
@synthesize cards=_cards;

- (NSString *)card_id {
  return [SSKeychain passwordForService:@"card_id" account:@"mail.ru"];
}

- (void)setCard_id:(NSString *)card_id {
  [SSKeychain setPassword:card_id forService:@"card_id" account:@"mail.ru"];
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
      _selectedCard = selectedCard;
    }
    else {
      [self updateCardSelection];
    }
    
  }
  
}

@end
