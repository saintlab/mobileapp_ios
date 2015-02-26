//
//  OMNMenuCategorySectionItem.h
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuCategory.h"
#import "OMNMenuCategoryHeaderView.h"

@interface OMNMenuCategorySectionItem : NSObject

@property (nonatomic, strong, readonly) OMNMenuCategory *menuCategory;
@property (nonatomic, weak) OMNMenuCategorySectionItem *parent;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL hidden;

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory;

+ (void)registerHeaderFooterViewForTableView:(UITableView *)tableView;

- (NSArray *)rowItems;
- (OMNMenuCategoryHeaderView *)headerViewForTableView:(UITableView *)tableView;

@end
