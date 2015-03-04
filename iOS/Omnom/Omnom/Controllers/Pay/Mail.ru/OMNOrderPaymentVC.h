//
//  OMNMailRUPayVC.h
//  omnom
//
//  Created by tea on 12.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//


#import "OMNBill.h"
#import "OMNAcquiringTransaction.h"
#import "OMNRestaurant.h"

@protocol OMNOrderPaymentVCDelegate;

@interface OMNOrderPaymentVC : UIViewController

@property (nonatomic, weak) id<OMNOrderPaymentVCDelegate> delegate;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant transaction:(OMNAcquiringTransaction *)acquiringTransaction;

@end

@protocol OMNOrderPaymentVCDelegate <NSObject>

- (void)orderPaymentVCDidFinish:(OMNOrderPaymentVC *)orderPaymentVC withBill:(OMNBill *)bill;
- (void)orderPaymentVCDidCancel:(OMNOrderPaymentVC *)orderPaymentVC;
- (void)orderPaymentVCOrderDidClosed:(OMNOrderPaymentVC *)orderPaymentVC;

@end