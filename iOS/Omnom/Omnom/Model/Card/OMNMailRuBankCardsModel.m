//
//  OMNMailRuBankCardsModel.m
//  omnom
//
//  Created by tea on 19.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRuBankCardsModel.h"
#import "OMNMailRuBankCardMediator.h"
#import "OMNBankCard.h"

@implementation OMNMailRuBankCardsModel

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock {

  __weak typeof(self)weakSelf = self;
  self.loading = YES;
  [OMNBankCard getCardsWithCompletion:^(NSArray *cards) {
    
    [weakSelf didLoadCards:cards];
    completionBlock();
    
  } failure:^(NSError *error) {
    
    [weakSelf didLoadCards:nil];
    completionBlock();
    
  }];
  
}

- (void)didLoadCards:(NSArray *)cards {
  
  if (cards) {
    
    self.cards = [cards mutableCopy];
    
  }
  
  [self updateCardSelection];
  self.loading = NO;
  
}

@end


