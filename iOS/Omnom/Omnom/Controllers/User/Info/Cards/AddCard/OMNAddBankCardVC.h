//
//  OMNAddBankCardsVC.h
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardInfo.h"

@protocol OMNAddBankCardVCDelegate;

@interface OMNAddBankCardVC : UIViewController

@property (nonatomic, assign) BOOL allowSaveCard;
@property (nonatomic, weak) id<OMNAddBankCardVCDelegate> delegate;

@end

@protocol OMNAddBankCardVCDelegate <NSObject>

- (void)addBankCardVC:(OMNAddBankCardVC *)addBankCardVC didAddCard:(OMNBankCardInfo *)bankCardInfo;

- (void)addBankCardVCDidCancel:(OMNAddBankCardVC *)addBankCardVC;

@end