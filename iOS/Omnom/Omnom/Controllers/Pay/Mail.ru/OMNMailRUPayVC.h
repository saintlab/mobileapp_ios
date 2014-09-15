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

#import "OMNBill.h"

@interface OMNMailRUPayVC : UIViewController

@property (nonatomic, weak) id<OMNMailRUPayVCDelegate> delegate;
@property (nonatomic, assign) BOOL demo;

- (instancetype)initWithOrder:(OMNOrder *)order;

@end

@protocol OMNMailRUPayVCDelegate <NSObject>

- (void)mailRUPayVCDidFinish:(OMNMailRUPayVC *)mailRUPayVC withBill:(OMNBill *)bill;

- (void)mailRUPayVCDidCancel:(OMNMailRUPayVC *)mailRUPayVC;

@end