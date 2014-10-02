//
//  OMNMailRUCardConfirmVC.h
//  omnom
//
//  Created by tea on 04.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//


@class OMNBankCardInfo;

@interface OMNMailRUCardConfirmVC : UIViewController

@property (nonatomic, copy) dispatch_block_t didFinishBlock;

- (instancetype)initWithCardInfo:(OMNBankCardInfo *)cardInfo;

@end
