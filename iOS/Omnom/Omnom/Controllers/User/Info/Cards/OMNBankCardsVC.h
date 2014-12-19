//
//  OMNBankCardsVC.h
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCard.h"
#import "OMNBankCardInfo.h"

@class OMNBankCardsVC;

typedef void(^OMNBankCardsVCDidSelectBlock)(__weak OMNBankCardsVC *bankCardsVC, OMNBankCard *bankCard);
typedef void(^OMNBankCardsVCDidCancelBlock)(__weak OMNBankCardsVC *bankCardsVC);

@interface OMNBankCardsVC : UITableViewController

- (instancetype)initWithDidSelectCardBlock:(OMNBankCardsVCDidSelectBlock)didSelectCardBlock cancelBlock:(OMNBankCardsVCDidCancelBlock)cancelBlock;

@end
