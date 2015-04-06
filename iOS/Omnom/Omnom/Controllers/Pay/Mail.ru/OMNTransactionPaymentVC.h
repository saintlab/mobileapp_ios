//
//  OMNMailRUPayVC.h
//  omnom
//
//  Created by tea on 12.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//


#import "OMNBill.h"
#import "OMNAcquiringTransaction.h"
#import "OMNVisitor.h"

@protocol OMNTransactionPaymentVCDelegate;

@interface OMNTransactionPaymentVC : UIViewController

@property (nonatomic, weak) id<OMNTransactionPaymentVCDelegate> delegate;
@property (nonatomic, strong, readonly) OMNAcquiringTransaction *acquiringTransaction;
@property (nonatomic, strong, readonly) OMNVisitor *visitor;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor transaction:(OMNAcquiringTransaction *)acquiringTransaction;

@end

@protocol OMNTransactionPaymentVCDelegate <NSObject>

- (void)transactionPaymentVCDidFinish:(OMNTransactionPaymentVC *)transactionPaymentVC withBill:(OMNBill *)bill;
- (void)transactionPaymentVCDidCancel:(OMNTransactionPaymentVC *)transactionPaymentVC;
- (void)transactionPaymentVCDidFail:(OMNTransactionPaymentVC *)transactionPaymentVC;

@end