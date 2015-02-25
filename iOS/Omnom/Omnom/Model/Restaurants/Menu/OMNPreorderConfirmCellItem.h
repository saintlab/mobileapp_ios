//
//  OMNMenuPreorderedCellItem.h
//  omnom
//
//  Created by tea on 25.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"
#import "OMNMenuProduct.h"

@interface OMNPreorderConfirmCellItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, strong, readonly) OMNMenuProduct *menuProduct;

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct;
- (void)editMenuProductFromController:(__weak UIViewController *)viewController withCompletion:(dispatch_block_t)completionBlock;

@end
