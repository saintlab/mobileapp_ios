//
//  OMNMenuProductExtended.h
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuCellItemProtocol.h"
#import "OMNMenuProduct.h"

@interface OMNMenuProductExtended : NSObject
<OMNMenuCellItemProtocol>

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct;

@end
