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

@property (nonatomic, copy) void(^addCardBlock)(OMNBankCardInfo *bankCardInfo);
@property (nonatomic, copy) dispatch_block_t cancelBlock;

@end
