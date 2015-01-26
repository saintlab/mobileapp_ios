//
//  OMNMenuProductDelimiter.h
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuCellItemProtocol.h"
#import "OMNMenuProductSelectionItem.h"

@interface OMNMenuProductRecommendationsDelimiter : NSObject
<OMNMenuCellItemProtocol>

- (instancetype)initWithMenuProductSelectionItem:(OMNMenuProductSelectionItem *)menuProductSelectionItem;

@end
