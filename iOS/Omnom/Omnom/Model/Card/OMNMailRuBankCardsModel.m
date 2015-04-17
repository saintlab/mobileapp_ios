//
//  OMNMailRuBankCardsModel.m
//  omnom
//
//  Created by tea on 19.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRuBankCardsModel.h"
#import "OMNMailRuBankCardMediator.h"
#import "OMNBankCard+omn_network.h"
#import "OMNAnalitics.h"

@implementation OMNMailRuBankCardsModel

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock {

  self.loading = YES;
  @weakify(self)
  [OMNBankCard getCardsWithCompletion:^(NSArray *cards) {
    
    @strongify(self)
    [self didLoadCards:cards];
    completionBlock();
    
  } failure:^(NSError *error) {
    
    @strongify(self)
    [self didLoadCards:nil];
    completionBlock();
    
  }];
  
}

- (void)didLoadCards:(NSArray *)cards {
  
  if (cards) {
    
    self.cards = [cards mutableCopy];
    [[OMNAnalitics analitics] logRegisterCards:cards];
    
  }
  
  [self updateCardSelection];
  self.loading = NO;
  
}

@end


