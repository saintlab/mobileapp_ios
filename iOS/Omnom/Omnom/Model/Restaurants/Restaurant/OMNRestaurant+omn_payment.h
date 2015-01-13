//
//  OMNRestaurant+payment.h
//  omnom
//
//  Created by tea on 05.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurant.h"
#import "OMNBankCardsModel.h"
#import "OMNBankCardMediator.h"

@interface OMNRestaurant (omn_payment)

- (OMNBankCardsModel *)bankCardsModel;
- (OMNBankCardMediator *)bankCardMediatorWithOrder:(OMNOrder *)order rootVC:(__weak UIViewController *)rootVC;

@end
