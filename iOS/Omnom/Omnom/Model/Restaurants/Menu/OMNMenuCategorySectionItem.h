//
//  OMNMenuCategorySectionItem.h
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuCategory.h"
#import "OMNMenuProductWithRecommendationsCellItem.h"

@class OMNMenuCategoryHeaderView;
@protocol OMNMenuCategoryHeaderViewDelegate;

@interface OMNMenuCategorySectionItem : NSObject

@property (nonatomic, strong, readonly) OMNMenuCategory *menuCategory;
@property (nonatomic, weak) id<OMNMenuCategoryHeaderViewDelegate> headerDelegate;
#warning OMNMenuCategoryHeaderViewDelegate
//@property (nonatomic, weak) id<OMNMenuCategoryHeaderViewDelegate> headerDelegate;
@property (nonatomic, weak) OMNMenuCategorySectionItem *parent;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL entered;

@property (nonatomic, assign) NSInteger insertedRowsCount;
@property (nonatomic, assign) NSInteger deletedRowsCount;

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory;

+ (void)registerCellsForTableView:(UITableView *)tableView;

- (NSArray *)rowItems;
- (void)close;
- (BOOL)visible;
- (UIView *)headerViewForTableView:(UITableView *)tableView;

@end

@protocol OMNMenuCategoryHeaderViewDelegate <NSObject>

- (void)menuCategoryHeaderViewDidSelect:(OMNMenuCategoryHeaderView *)menuCategoryHeaderView;

@end