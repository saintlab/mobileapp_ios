//
//  OMNMenuCategoriesModel.h
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenu.h"
#import "OMNMenuProductWithRecommedtationsCell.h"
#import "OMNMenuCategoryHeaderView.h"
#import "NSArray+omn_tableHelper.h"

typedef void(^OMNMenuTableDidEndDraggingBlock)(UITableView *tableView);

@interface OMNMenuCategoriesModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong, readonly) NSArray *allCategories;
@property (nonatomic, strong, readonly) NSArray *visibleCategories;
@property (nonatomic, copy) OMNMenuTableDidEndDraggingBlock didEndDraggingBlock;

- (instancetype)initWithMenu:(OMNMenu *)menu cellDelegate:(id<OMNMenuProductWithRecommedtationsCellDelegate>)cellDelegate headerDelegate:(id<OMNMenuCategoryHeaderViewDelegate>)headerDelegate;

+ (void)registerCellsForTableView:(UITableView *)tableView;

- (void)updateWithCompletion:(OMNTableReloadDataBlock)block;
- (void)selectMenuCategoryItem:(OMNMenuCategorySectionItem *)selectedItem withCompletion:(OMNTableReloadDataBlock)block;
- (void)closeAllCategoriesWithCompletion:(OMNTableReloadDataBlock)block;

@end
