//
//  OMNTestPaymentFactory.m
//  omnom
//
//  Created by tea on 04.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNTestPaymentFactory.h"
#import "OMNMailAcquiringTransaction.h"
#import "OMNTestBankCardMediator.h"

@implementation OMNTestPaymentFactory

- (OMNBankCardMediator *)bankCardMediatorWithRootVC:(UIViewController *)rootVC transaction:(OMNAcquiringTransaction *)transaction {
  
  OMNBankCardMediator *bankCardMediator = [[OMNTestBankCardMediator alloc] initWithRootVC:rootVC transaction:transaction];
  return bankCardMediator;
  
}

- (OMNAcquiringTransaction *)transactionForOrder:(OMNOrder *)order {
  
  return [[OMNMailAcquiringTransaction alloc] initWithOrder:order];
  
}

@end
