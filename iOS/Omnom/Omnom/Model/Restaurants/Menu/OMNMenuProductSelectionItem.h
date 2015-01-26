//
//  OMNMenuProductSelectionItem.h
//  omnom
//
//  Created by tea on 26.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNMenuProduct.h"
#import "OMNMenuCellItemProtocol.h"

@interface OMNMenuProductSelectionItem : NSObject
<OMNMenuCellItemProtocol>

@property (nonatomic, weak) OMNMenuProductSelectionItem *parent;
@property (nonatomic, weak) OMNMenuProduct *menuProduct;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct;

@end
