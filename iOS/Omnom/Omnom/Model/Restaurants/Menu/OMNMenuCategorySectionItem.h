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
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL entered;

@property (nonatomic, assign) NSInteger insertedRowsCount;
@property (nonatomic, assign) NSInteger deletedRowsCount;

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory;

+ (void)registerHeaderFooterViewForTableView:(UITableView *)tableView;

- (NSArray *)rowItems;
- (void)close;
- (BOOL)visible;
- (OMNMenuCategoryHeaderView *)headerViewForTableView:(UITableView *)tableView;

@end
