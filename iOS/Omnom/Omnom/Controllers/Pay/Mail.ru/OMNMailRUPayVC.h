//
//  OMNMailRUPayVC.h
//  omnom
//
//  Created by tea on 12.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNBankCardInfo;
@class OMNOrder;
@protocol OMNMailRUPayVCDelegate;

@interface OMNMailRUPayVC : UIViewController

@property (nonatomic, weak) id<OMNMailRUPayVCDelegate> delegate;

- (instancetype)initWithOrder:(OMNOrder *)order bankCardInfo:(OMNBankCardInfo *)bankCardInfo;

@end

@protocol OMNMailRUPayVCDelegate <NSObject>

- (void)mailRUPayVCDidFinish:(OMNMailRUPayVC *)mailRUPayVC;

- (void)mailRUPayVCDidCancel:(OMNMailRUPayVC *)mailRUPayVC;

@end