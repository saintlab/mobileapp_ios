//
//  OMNBankCardsVC.h
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCard.h"
#import "OMNBankCardInfo.h"

@protocol OMNBankCardsVCDelegate;

@interface OMNBankCardsVC : UITableViewController

@property (nonatomic, weak) id<OMNBankCardsVCDelegate> delegate;

@end

@protocol OMNBankCardsVCDelegate <NSObject>

- (void)bankCardsVC:(OMNBankCardsVC *)bankCardsVC didSelectCard:(OMNBankCard *)bankCard;
- (void)bankCardsVCDidCancel:(OMNBankCardsVC *)bankCardsVC;

@end
