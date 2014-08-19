//
//  OMNMailRuBankCardsModel.m
//  omnom
//
//  Created by tea on 19.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRuBankCardsModel.h"
#import <SSKeychain.h>
#import "OMNAuthorisation.h"

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

- (OMNMailRuPaymentInfo *)selectedCardPaymentInfo {
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  
  paymentInfo.cardInfo.card_id = _selectedCard.external_card_id;
  paymentInfo.cardInfo.cvv = @"123";
#warning paymentInfo.cardInfo.pan = @"6011000000000004"
  //  if ([self.selectedCard isEqual:self.customCard]) {
  //    paymentInfo.cardInfo.pan = @"4111111111111112";
  //    paymentInfo.cardInfo.pan = @"6011000000000004";
  //    paymentInfo.cardInfo.pan = @"639002000000000003",
  //    paymentInfo.cardInfo.exp_date = @"12.2015";
  //    paymentInfo.cardInfo.cvv = @"123";
  //  }
  
  paymentInfo.user_phone = [OMNAuthorisation authorisation].user.phone;
  paymentInfo.user_login = [OMNAuthorisation authorisation].user.id;
  paymentInfo.order_message = @"message";
  
  return paymentInfo;
  
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
    [_cards enumerateObjectsUsingBlock:^(OMNBankCard *bankCard, NSUInteger idx, BOOL *stop) {
      if ([bankCard.id isEqualToString:self.card_id]) {
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
