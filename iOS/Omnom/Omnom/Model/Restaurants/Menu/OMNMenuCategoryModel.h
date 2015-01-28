//
//  OMNMenuCategoryModel.h
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuCategory.h"
#import "OMNMenuProductWithRecommedtationsCell.h"

@interface OMNMenuCategoryModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong, readonly) OMNMenuCategory *menuCategory;

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory delegate:(__weak id<OMNMenuProductWithRecommedtationsCellDelegate>)delegate;
+ (void)registerCellsForTableView:(UITableView *)tableView;

@end
