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
@property (nonatomic, assign) BOOL allowSaveCard;

@end

@protocol OMNBankCardsVCDelegate <NSObject>

- (void)bankCardsVC:(OMNBankCardsVC *)bankCardsVC didSelectCard:(OMNBankCard *)bankCard;

- (void)bankCardsVC:(OMNBankCardsVC *)bankCardsVC didCreateCard:(OMNBankCardInfo *)bankCardInfo;

- (void)bankCardsVCDidCancel:(OMNBankCardsVC *)bankCardsVC;

@end
