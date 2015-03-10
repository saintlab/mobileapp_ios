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

@protocol OMNTransactionPaymentVCDelegate;

@interface OMNTransactionPaymentVC : UIViewController

@property (nonatomic, weak) id<OMNTransactionPaymentVCDelegate> delegate;
@property (nonatomic, strong, readonly) OMNAcquiringTransaction *acquiringTransaction;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant transaction:(OMNAcquiringTransaction *)acquiringTransaction;

@end

@protocol OMNTransactionPaymentVCDelegate <NSObject>

- (void)transactionPaymentVCDidFinish:(OMNTransactionPaymentVC *)transactionPaymentVC withBill:(OMNBill *)bill;
- (void)transactionPaymentVCDidCancel:(OMNTransactionPaymentVC *)transactionPaymentVC;
- (void)transactionPaymentVCDidFail:(OMNTransactionPaymentVC *)transactionPaymentVC;

@end