//
//  OMNPaidPreorderMediator.h
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNWishMediator.h"
#import "OMNTransactionPaymentVC.h"

@interface OMNPaidWishMediator : OMNWishMediator

- (PMKPromise *)payForVisitor:(OMNVisitor *)visitor;

@end
