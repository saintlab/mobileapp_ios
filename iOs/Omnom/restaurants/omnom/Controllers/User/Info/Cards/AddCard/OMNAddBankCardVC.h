//
//  OMNAddBankCardsVC.h
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCard.h"

@protocol OMNAddBankCardVCDelegate;

@interface OMNAddBankCardVC : UIViewController

@property (nonatomic, weak) id<OMNAddBankCardVCDelegate> delegate;

@end

@protocol OMNAddBankCardVCDelegate <NSObject>

- (void)addBankCardVC:(OMNAddBankCardVC *)addBankCardVC didAddCard:(OMNBankCard *)card;

- (void)addBankCardVCDidCancel:(OMNAddBankCardVC *)addBankCardVC;

@end