//
//  OMNMailRuPaymentFactory.m
//  omnom
//
//  Created by tea on 04.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMailRuPaymentFactory.h"
#import "OMNMailRuBankCardMediator.h"
#import "OMNMailAcquiringTransaction.h"

@implementation OMNMailRuPaymentFactory

- (OMNBankCardMediator *)bankCardMediatorWithRootVC:(UIViewController *)rootVC transaction:(OMNAcquiringTransaction *)transaction {
  
  OMNBankCardMediator *bankCardMediator = [[OMNMailRuBankCardMediator alloc] initWithRootVC:rootVC transaction:transaction];
  return bankCardMediator;
  
}

- (OMNAcquiringTransaction *)transactionForOrder:(OMNOrder *)order {
  return [[OMNMailAcquiringTransaction alloc] initWithOrder:order];
}

- (OMNAcquiringTransaction *)transactionForWish:(OMNWish *)wish {
  return [[OMNMailAcquiringTransaction alloc] initWithWish:wish];
}

@end
