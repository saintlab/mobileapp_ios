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

@interface OMNMenuCategoriesModel ()
<OMNMenuCategoryHeaderViewDelegate>

@end

@implementation OMNMenuCategoriesModel {
  
  OMNMenu *_menu;
  NSMutableArray *_menuCategorySectionItems;
  UITableView *_tableView;
  __weak id<OMNMenuProductWithRecommedtationsCellDelegate> _delegate;
  
}

- (instancetype)initWithMenu:(OMNMenu *)menu delegate:(id<OMNMenuProductWithRecommedtationsCellDelegate>)delegate {
  self = [super init];
  if (self) {
    
    _menu = menu;
    _delegate = delegate;
    
  }
  return self;
}

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [OMNMenuProductWithRecommendationsCellItem registerCellForTableView:tableView];
  [OMNMenuCategorySectionItem registerHeaderFooterViewForTableView:tableView];
  [OMNMenuCategoryDelimiterCellItem registerCellForTableView:tableView];
  [OMNMenuProductsDelimiterCellItem registerCellForTableView:tableView];
  
}

- (NSArray *)categoriesList {
  
  if (_menuCategorySectionItems) {
    return _menuCategorySectionItems;
  }
  
  NSMutableArray *menuCategorySectionItems = [NSMutableArray array];
  
  [_menu.categories enumerateObjectsUsingBlock:^(OMNMenuCategory *menuCategory, NSUInteger idx, BOOL *stop) {
    
    OMNMenuCategorySectionItem *parent = [[OMNMenuCategorySectionItem alloc] initWithMenuCategory:menuCategory];
    [menuCategorySectionItems addObject:parent];

    [menuCategorySectionItems addObjectsFromArray:[menuCategory.children bk_map:^id(OMNMenuCategory *childCategory) {
      
      OMNMenuCategorySectionItem *child = [[OMNMenuCategorySectionItem alloc] initWithMenuCategory:childCategory];
      child.parent = parent;
      return child;
      
    }]];
    
  }];
  
  _menuCategorySectionItems = menuCategorySectionItems;
  
  return _menuCategorySectionItems;
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  _tableView = tableView;
  return self.categoriesList.count;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.categoriesList[section];
  return menuCategorySectionItem.rowItems.count;

}

- (id)listItemAtIndexPath:(NSIndexPath *)indexPath {
  
  id listItem = nil;
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.categoriesList[indexPath.section];
  listItem = menuCategorySectionItem.rowItems[indexPath.row];
  return listItem;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id listItem = [self listItemAtIndexPath:indexPath];
  
  if ([listItem conformsToProtocol:@protocol(OMNCellItemProtocol)]) {
    
    UITableViewCell *cell = [listItem cellForTableView:tableView];
    
    if ([cell isKindOfClass:[OMNMenuProductWithRecommedtationsCell class]]) {
      
      OMNMenuProductWithRecommedtationsCell *productWithRecommedtationsCell = (OMNMenuProductWithRecommedtationsCell *)cell;
      productWithRecommedtationsCell.delegate = _delegate;
      
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
  
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.categoriesList[section];
  OMNMenuCategoryHeaderView *menuCategoryHeaderView = [menuCategorySectionItem headerViewForTableView:tableView];
  menuCategoryHeaderView.delegate = self;
  return menuCategoryHeaderView;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.categoriesList[section];
  
//  if (menuCategorySectionItem.parent &&
//      !menuCategorySectionItem.parent.selected) {
//    return 0.0f;
//  }
  
  CGFloat heightForHeader = 44.0f;
  return heightForHeader;
  
}

#pragma mark - OMNMenuCategoryHeaderViewDelegate

- (void)menuCategoryHeaderViewDidSelect:(OMNMenuCategoryHeaderView *)menuCategoryHeaderView {
  
  if (menuCategoryHeaderView.menuCategorySectionItem.selected) {
    return;
  }
  
  NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
  __block NSInteger selectedIndex = NSNotFound;
  
  [_menuCategorySectionItems enumerateObjectsUsingBlock:^(OMNMenuCategorySectionItem *sectionItem, NSUInteger idx, BOOL *stop) {
    
    if (sectionItem.selected) {
      [indexSet addIndex:idx];
    }
    
    if ([sectionItem isEqual:menuCategoryHeaderView.menuCategorySectionItem]) {
    
      [indexSet addIndex:idx];
      sectionItem.selected = YES;
      selectedIndex = idx;
      
    }
    else {
      
      sectionItem.selected = NO;
      
    }

  }];
  
  [_tableView beginUpdates];
  [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
  [_tableView endUpdates];
  if (NSNotFound != selectedIndex &&
      menuCategoryHeaderView.menuCategorySectionItem.rowItems.count) {
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
  }
  
}

@end
