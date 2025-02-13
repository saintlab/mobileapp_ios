//
//  OMNMenuCategoryCellItem.h
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"
#import "OMNMenuCategory.h"

@interface OMNMenuCategoryDelimiterCellItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, strong, readonly) OMNMenuCategory *menuCategory;

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory;

@end
