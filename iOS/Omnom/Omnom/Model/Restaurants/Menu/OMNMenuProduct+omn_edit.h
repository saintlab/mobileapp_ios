//
//  OMNMenuProduct+omn_edit.h
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProduct.h"

@interface OMNMenuProduct (omn_edit)

- (void)editMenuProductFromController:(__weak UIViewController *)viewController withCompletion:(dispatch_block_t)completionBlock;

@end
