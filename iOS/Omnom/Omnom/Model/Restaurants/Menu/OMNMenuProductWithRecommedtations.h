//
//  OMNMenuProductWithRecommedtations.h
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuCellItemProtocol.h"
#import "OMNMenuProduct.h"
#import "OMNMenuProductsDelimiter.h"

@interface OMNMenuProductWithRecommedtations : NSObject
<OMNMenuCellItemProtocol>

@property (nonatomic, weak) OMNMenuProductsDelimiter *bottomDelimetr;

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products;

@end
