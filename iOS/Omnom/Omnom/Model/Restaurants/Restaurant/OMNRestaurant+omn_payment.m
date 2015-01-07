//
//  OMNRestaurant+payment.m
//  omnom
//
//  Created by tea on 05.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurant+omn_payment.h"
#import "OMNTestBankCardsModel.h"
#import "OMNMailRuBankCardsModel.h"

@implementation OMNRestaurant (omn_payment)

- (OMNBankCardsModel *)bankCardsModelWithRootVC:(__weak UIViewController *)vc {

  OMNBankCardsModel *bankCardsModel = nil;
  if (self.is_demo) {
    
    bankCardsModel = [[OMNTestBankCardsModel alloc] initWithRootVC:vc];
    
  }
  else {
    
    bankCardsModel = [[OMNMailRuBankCardsModel alloc] initWithRootVC:vc];
    
  }
  
  return bankCardsModel;
  
}

@end
