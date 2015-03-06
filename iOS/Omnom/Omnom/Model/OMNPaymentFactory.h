//
//  OMNPaymentFactory.h
//  omnom
//
//  Created by tea on 04.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNBankCardMediator.h"
#import "OMNAcquiringTransaction.h"
#import "OMNBankCardsModel.h"
#import "OMNWish.h"

@protocol OMNPaymentFactory <NSObject>

- (OMNBankCardMediator *)bankCardMediatorWithRootVC:(UIViewController *)rootVC transaction:(OMNAcquiringTransaction *)transaction;
- (OMNAcquiringTransaction *)transactionForOrder:(OMNOrder *)order;
- (OMNAcquiringTransaction *)transactionForWish:(OMNWish *)wish;

@end