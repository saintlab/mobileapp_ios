//
//  OMNRatingVC.h
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNAcquiringTransaction.h"
#import "OMNBill.h"

@interface OMNRatingVC : OMNBackgroundVC

@property (nonatomic, copy) dispatch_block_t didFinishBlock;

- (instancetype)initWithTransaction:(OMNAcquiringTransaction *)transaction bill:(OMNBill *)bill;

@end
