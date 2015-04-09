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

- (NSArray *)sectionItemsWithParent:(OMNMenuCategorySectionItem *)parentItem;

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
      
      NSArray *sectionItems = [menuCategory sectionItemsWithParent:nil];
      [menuCategorySectionItems addObjectsFromArray:sectionItems];
      
    }];
    
    _allCategories = [menuCategorySectionItems copy];
    
  }
  return self;
}

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [OMNMenuProductWithRecommendationsCellItem registerCellForTableView:tableView];
  [OMNMenuCategorySectionItem registerHeaderFooterViewForTableView:tableView];
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
    
    UITableViewCell *cell = [listItem cellForTableView:tableView];
    
    if ([cell isKindOfClass:[OMNMenuProductWithRecommedtationsCell class]]) {
      
      OMNMenuProductWithRecommedtationsCell *productWithRecommedtationsCell = (OMNMenuProductWithRecommedtationsCell *)cell;
      productWithRecommedtationsCell.delegate = _cellDelegate;
      
    }
    
    return cell;
    
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
  OMNMenuCategoryHeaderView *menuCategoryHeaderView = [menuCategorySectionItem headerViewForTableView:tableView];
  menuCategoryHeaderView.delegate = _headerDelegate;
  return menuCategoryHeaderView;
  
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

- (void)closeAllCategoriesWithCompletion:(OMNUpdatedIndexesAndRowsBlock)block {
  
  NSMutableArray *deletedRows = [NSMutableArray array];
  [self.allCategories enumerateObjectsUsingBlock:^(OMNMenuCategorySectionItem *item, NSUInteger idx, BOOL *stop) {
    
    if (item.rowItems.count) {
      item.deletedRowsCount = item.rowItems.count;
    }
    [item close];
    [deletedRows addObjectsFromArray:[self indexPathsWithSection:[self.visibleCategories indexOfObject:item] maxRows:item.deletedRowsCount]];
    
  }];
  
  [self updateWithCompletion:^(NSIndexSet *deletedIndexes, NSIndexSet *insertedIndexes, NSIndexSet *reloadIndexes) {
    
    block(deletedIndexes, insertedIndexes, reloadIndexes, deletedRows, @[]);
    
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

- (void)selectMenuCategoryItem:(OMNMenuCategorySectionItem *)selectedItem withCompletion:(OMNUpdatedIndexesAndRowsBlock)block {
  
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
  
  [self updateWithCompletion:^(NSIndexSet *deletedIndexes, NSIndexSet *insertedIndexes, NSIndexSet *reloadIndexes) {
    
    NSMutableArray *insertedRows = [NSMutableArray array];
    NSMutableArray *deletedRows = [NSMutableArray array];
    [self.visibleCategories enumerateObjectsUsingBlock:^(OMNMenuCategorySectionItem *item, NSUInteger idx, BOOL *stop) {
      
      [insertedRows addObjectsFromArray:[self indexPathsWithSection:idx maxRows:item.insertedRowsCount]];

    }];

    [initialCategories enumerateObjectsUsingBlock:^(OMNMenuCategorySectionItem *item, NSUInteger idx, BOOL *stop) {
      
      if ([self.visibleCategories containsObject:item]) {
        [deletedRows addObjectsFromArray:[self indexPathsWithSection:idx maxRows:item.deletedRowsCount]];
      }
      
    }];
    
    block(deletedIndexes, insertedIndexes, reloadIndexes, deletedRows, insertedRows);
    
  }];
  
}

- (void)updateWithCompletion:(OMNUpdatedIndexesBlock)block {
  
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
    block([NSIndexSet indexSet], [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newVisibleCategories.count)], [NSIndexSet indexSet]);
    
  }
  
}

@end

@implementation OMNMenuCategory (omn_categories)

- (NSArray *)sectionItemsWithParent:(OMNMenuCategorySectionItem *)parentItem {
  
  NSMutableArray *menuCategorySectionItems = [NSMutableArray array];
  
  OMNMenuCategorySectionItem *sectionItem = [[OMNMenuCategorySectionItem alloc] initWithMenuCategory:self];
  sectionItem.parent = parentItem;
  [menuCategorySectionItems addObject:sectionItem];

  [self.children enumerateObjectsUsingBlock:^(OMNMenuCategory *menuCategory, NSUInteger idx, BOOL *stop) {
    
    NSArray *childItems = [menuCategory sectionItemsWithParent:sectionItem];
    [menuCategorySectionItems addObjectsFromArray:childItems];
    
  }];
  
  return menuCategorySectionItems;
  
}

@end
