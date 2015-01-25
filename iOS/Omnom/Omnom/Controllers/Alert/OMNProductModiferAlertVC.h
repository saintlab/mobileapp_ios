//
//  OMNProductModiferAlertVC.h
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"
#import "OMNMenuProduct.h"

@interface OMNProductModiferAlertVC : OMNModalAlertVC

@property (nonatomic, copy) dispatch_block_t didSelectOrderBlock;

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct;

@end
