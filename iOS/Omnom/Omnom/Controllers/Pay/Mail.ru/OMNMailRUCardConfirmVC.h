//
//  OMNMailRUCardConfirmVC.h
//  omnom
//
//  Created by tea on 04.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//


@class OMNBankCardInfo;
@protocol OMNMailRUCardConfirmVCDelegate;

@interface OMNMailRUCardConfirmVC : UIViewController

@property (nonatomic, weak) id<OMNMailRUCardConfirmVCDelegate> delegate;

- (instancetype)initWithCardInfo:(OMNBankCardInfo *)cardInfo;

@end

@protocol OMNMailRUCardConfirmVCDelegate <NSObject>

- (void)mailRUCardConfirmVCDidFinish:(OMNMailRUCardConfirmVC *)mailRUCardConfirmVC;

@end