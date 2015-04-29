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

@interface OMNTransactionPaymentVC : UIViewController

@property (nonatomic, strong, readonly) OMNAcquiringTransaction *acquiringTransaction;
@property (nonatomic, strong, readonly) OMNVisitor *visitor;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor transaction:(OMNAcquiringTransaction *)acquiringTransaction;
- (PMKPromise *)pay:(UIViewController *)presentingVC;

@end
