//
//  OMNMenuProductCellDelegate.h
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMNMenuProductCell;
@class OMNMenuProduct;

@protocol OMNMenuProductCellDelegate <NSObject>

- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell didSelectProduct:(OMNMenuProduct *)menuProduct;
- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell editProduct:(OMNMenuProduct *)menuProduct;

@end
