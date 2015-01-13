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

#import "OMNTestBankCardMediator.h"
#import "OMNMailRuBankCardMediator.h"

@implementation OMNRestaurant (omn_payment)

- (OMNBankCardsModel *)bankCardsModel {

  OMNBankCardsModel *bankCardsModel = nil;
  if (self.is_demo) {
    
    bankCardsModel = [[OMNTestBankCardsModel alloc] init];
    
  }
  else {
    
    bankCardsModel = [[OMNMailRuBankCardsModel alloc] init];
    
  }
  
  return bankCardsModel;
  
}

- (OMNBankCardMediator *)bankCardMediatorWithOrder:(OMNOrder *)order rootVC:(__weak UIViewController *)rootVC {
  
  OMNBankCardMediator *bankCardMediator = nil;
  if (self.is_demo) {
    
    bankCardMediator = [[OMNTestBankCardMediator alloc] initWithOrder:order rootVC:rootVC];
    
  }
  else {
    
    bankCardMediator = [[OMNMailRuBankCardMediator alloc] initWithOrder:order rootVC:rootVC];
    
  }
  
  return bankCardMediator;
  
}

@end
