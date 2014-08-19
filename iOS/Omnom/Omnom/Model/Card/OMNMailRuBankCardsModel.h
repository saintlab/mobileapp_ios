//
//  OMNMailRuBankCardsModel.h
//  omnom
//
//  Created by tea on 19.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OMNMailRuPaymentInfo.h>
#import "OMNBankCardsModel.h"

@interface OMNMailRuBankCardsModel : OMNBankCardsModel

@property (nonatomic, strong, readonly) OMNMailRuPaymentInfo *selectedCardPaymentInfo;

@end
