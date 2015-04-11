//
//  OMNMenuCategoriesModel.m
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategoriesModel.h"
#import "OMNMenuCategorySectionItem.h"
#import <BlocksKit.h>
#import "OMNMenuCategoryDelimiterCellItem.h"
#import "OMNMenuProductsDelimiterCellItem.h"

@interface OMNMenuCategory (omn_categories)

- (NSArray *)sectionItemsWithParent:(OMNMenuCategorySectionItem *)parentItem  cellDelegate:(id<OMNMenuProductWithRecommedtationsCellDelegate>)cellDelegate headerDelegate:(id<OMNMenuCategoryHeaderViewDelegate>)headerDelegate;

@end

@implementation OMNMenuCategoriesModel {
  
  OMNMenu *_menu;
  __weak id<OMNMenuProductWithRecommedtationsCellDelegate> _cellDelegate;
  __weak id<OMNMenuCategoryHeaderViewDelegate> _headerDelegate;
  
}

- (instancetype)initWithMenu:(OMNMenu *)menu cellDelegate:(id<OMNMenuProductWithRecommedtationsCellDelegate>)cellDelegate headerDelegate:(id<OMNMenuCategoryHeaderViewDelegate>)headerDelegate {
  self = [super init];
  if (self) {
    
    _menu = menu;
    _cellDelegate = cellDelegate;
    _headerDelegate = headerDelegate;
    
    NSMutableArray *menuCategorySectionItems = [NSMutableArray array];
    
    [_menu.categories enumerateObjectsUsingBlock:^(OMNMenuCategory *menuCategory, NSUInteger idx, BOOL *stop) {
      
      NSArray *sectionItems = [menuCategory sectionItemsWithParent:nil cellDelegate:cellDelegate headerDelegate:headerDelegate];
      [menuCategorySectionItems addObjectsFromArray:sectionItems];
      
    }];
    
    _allCategories = [menuCategorySectionItems copy];
    
  }
  return self;
}

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [OMNMenuProductWithRecommendationsCellItem registerCellForTableView:tableView];
  [OMNMenuCategorySectionItem registerCellsForTableView:tableView];
  [OMNMenuCategoryDelimiterCellItem registerCellForTableView:tableView];
  [OMNMenuProductsDelimiterCellItem registerCellForTableView:tableView];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.visibleCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.visibleCategories[section];
  return menuCategorySectionItem.rowItems.count;

}

- (id)listItemAtIndexPath:(NSIndexPath *)indexPath {
  
  id listItem = nil;
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.visibleCategories[indexPath.section];
  listItem = menuCategorySectionItem.rowItems[indexPath.row];
  return listItem;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id listItem = [self listItemAtIndexPath:indexPath];
  
  if ([listItem conformsToProtocol:@protocol(OMNCellItemProtocol)]) {
    
    return  [listItem cellForTableView:tableView];
    
  }
  else {
    
    return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
  }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id listItem = [self listItemAtIndexPath:indexPath];
  if ([listItem conformsToProtocol:@protocol(OMNCellItemProtocol)]) {
    
    return [listItem heightForTableView:tableView];
    
  }
  return 100.0f;
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.visibleCategories[section];
  return [menuCategorySectionItem headerViewForTableView:tableView];
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.visibleCategories[section];
  CGFloat heightForHeader = (menuCategorySectionItem.visible) ? (44.0f) : (0.0f);
  return heightForHeader;
  
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  
  if (self.didEndDraggingBlock) {
    self.didEndDraggingBlock((UITableView *)scrollView);
  }
  
}

- (void)closeAllCategoriesWithCompletion:(OMNTableReloadDataBlock)block {
  
  NSMutableArray *deletedIndexPaths = [NSMutableArray array];
  [self.allCategories enumerateObjectsUsingBlock:^(OMNMenuCategorySectionItem *item, NSUInteger idx, BOOL *stop) {
    
    if (item.rowItems.count &&
        [self.visibleCategories containsObject:item]) {
      
      item.deletedRowsCount = item.rowItems.count;
      
    }
    else {
      item.deletedRowsCount = 0;
    }
    
    [item close];
    [deletedIndexPaths addObjectsFromArray:[self indexPathsWithSection:[self.visibleCategories indexOfObject:item] maxRows:item.deletedRowsCount]];
    
  }];
  
  [self updateWithCompletion:^(OMNTableReloadData *data) {
    
    block([data dataWithDeletedIndexPaths:deletedIndexPaths insertedIndexPaths:nil]);
    
  }];
  
}

- (NSArray *)indexPathsWithSection:(NSInteger)section maxRows:(NSInteger)maxRows {
  
  if (NSNotFound == section ||
      NSNotFound == maxRows) {
    return @[];
  }
  
  NSMutableArray *rows = [NSMutableArray array];
  for (int row = 0; row < maxRows; row++) {
    [rows addObject:[NSIndexPath indexPathForRow:row inSection:section]];
  }
  return rows;
  
}

- (void)selectMenuCategoryItem:(OMNMenuCategorySectionItem *)selectedItem withCompletion:(OMNTableReloadDataBlock)block {
  
  NSInteger selectedCategoryLevel = selectedItem.menuCategory.level;
  NSArray *initialCategories = [self.visibleCategories copy];
  [self.allCategories enumerateObjectsUsingBlock:^(OMNMenuCategorySectionItem *item, NSUInteger idx, BOOL *stop) {
    
    if (![item isEqual:selectedItem] &&
        item.menuCategory.level >= selectedCategoryLevel) {

      item.entered = NO;
      
    }

    NSInteger initialRowsCount = item.rowItems.count;
    item.selected = ([item isEqual:selectedItem]) ? (!item.selected) : (NO);
    item.insertedRowsCount = 0;
    item.deletedRowsCount= 0;

    if (initialRowsCount != item.rowItems.count) {
      
      if (item.selected) {
        item.insertedRowsCount = item.rowItems.count;
      }
      else {
        item.deletedRowsCount = initialRowsCount;
      }
      
    }
    
  }];
  
  selectedItem.entered = !selectedItem.entered;
  
  [self updateWithCompletion:^(OMNTableReloadData *data) {
    
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];
    NSMutableArray *deletedIndexPaths = [NSMutableArray array];
    [self.visibleCategories enumerateObjectsUsingBlock:^(OMNMenuCategorySectionItem *item, NSUInteger idx, BOOL *stop) {
      
      [insertedIndexPaths addObjectsFromArray:[self indexPathsWithSection:idx maxRows:item.insertedRowsCount]];

    }];

    [initialCategories enumerateObjectsUsingBlock:^(OMNMenuCategorySectionItem *item, NSUInteger idx, BOOL *stop) {
      
      if ([self.visibleCategories containsObject:item]) {
        [deletedIndexPaths addObjectsFromArray:[self indexPathsWithSection:idx maxRows:item.deletedRowsCount]];
      }
      
    }];
    
    block([data dataWithDeletedIndexPaths:deletedIndexPaths insertedIndexPaths:insertedIndexPaths]);
    
  }];
  
}

- (void)updateWithCompletion:(OMNTableReloadDataBlock)block {
  
  NSArray *newVisibleCategories = [self.allCategories bk_select:^BOOL(OMNMenuCategorySectionItem *item) {
    
    return item.visible;
    
  }];
  
  if (_visibleCategories) {
    
    NSArray *oldCategories = [_visibleCategories copy];
    _visibleCategories = newVisibleCategories;
    [oldCategories omn_compareToArray:newVisibleCategories withCompletion:block];
    
  }
  else {
    
    _visibleCategories = newVisibleCategories;
    block([OMNTableReloadData new]);
    
  }
  
}

@end

@implementation OMNMenuCategory (omn_categories)

- (NSArray *)sectionItemsWithParent:(OMNMenuCategorySectionItem *)parentItem  cellDelegate:(id<OMNMenuProductWithRecommedtationsCellDelegate>)cellDelegate headerDelegate:(id<OMNMenuCategoryHeaderViewDelegate>)headerDelegate {
  
  NSMutableArray *menuCategorySectionItems = [NSMutableArray array];
  
  OMNMenuCategorySectionItem *sectionItem = [[OMNMenuCategorySectionItem alloc] initWithMenuCategory:self];
  sectionItem.parent = parentItem;
  sectionItem.headerDelegate = headerDelegate;
  sectionItem.cellWithRecommendationDelegate = cellDelegate;
  [menuCategorySectionItems addObject:sectionItem];

  [self.children enumerateObjectsUsingBlock:^(OMNMenuCategory *menuCategory, NSUInteger idx, BOOL *stop) {
    
    NSArray *childItems = [menuCategory sectionItemsWithParent:sectionItem cellDelegate:cellDelegate headerDelegate:headerDelegate];
    [menuCategorySectionItems addObjectsFromArray:childItems];
    
  }];
  
  return menuCategorySectionItems;
  
}

@end
