//
//  OMNAddBankCardsVC.h
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardInfo.h"

typedef NS_OPTIONS(NSUInteger, OMNAddBankPurpose) {
  kAddBankPurposeRegister = 1 << 0,
  kAddBankPurposePayment  = 1 << 1,
  kAddBankPurposeAll = (kAddBankPurposeRegister|kAddBankPurposePayment),
};


@interface OMNAddBankCardVC : UIViewController

@property (nonatomic, assign) OMNAddBankPurpose purpose;
@property (nonatomic, copy) void(^addCardBlock)(OMNBankCardInfo *bankCardInfo);
@property (nonatomic, copy) dispatch_block_t cancelBlock;

@end
