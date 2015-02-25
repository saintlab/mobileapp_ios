//
//  OMNMenuProductCellItem+edit.h
//  omnom
//
//  Created by tea on 24.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductCellItem.h"

@interface OMNMenuProductCellItem (edit)

- (void)editMenuProductFromController:(__weak UIViewController *)viewController withCompletion:(dispatch_block_t)completionBlock;

@end
