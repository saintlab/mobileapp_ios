//
//  OMNMenuItemVC.h
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNMenuCategory.h"

@interface OMNMenuCategoryVC : OMNBackgroundVC

@property (nonatomic, strong, readonly) OMNMenuCategory *menuCategory;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;
@property (nonatomic, strong, readonly) UITableView *tableView;

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory;

@end
