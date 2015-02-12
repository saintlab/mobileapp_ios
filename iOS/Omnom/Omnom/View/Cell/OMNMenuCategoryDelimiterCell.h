//
//  OMNMenuCategoryDelimiterCell.h
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuCategory.h"

@interface OMNMenuCategoryDelimiterCell : UITableViewCell

@property (nonatomic, strong) OMNMenuCategory *menuCategory;

@end

@interface OMNMenuCategoryDelimiterView : UIView

@property (nonatomic, strong) OMNMenuCategory *menuCategory;

@end