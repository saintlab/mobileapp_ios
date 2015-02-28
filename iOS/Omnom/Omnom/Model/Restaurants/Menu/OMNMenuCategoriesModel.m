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

@implementation OMNMenuCategoriesModel {
  
  OMNMenu *_menu;
  __weak id<OMNMenuProductWithRecommedtationsCellDelegate> _cellDelegate;
  __weak id<OMNMenuCategoryHeaderViewDelegate> _headerDelegate;
  
}

@synthesize categories=_categories;

- (instancetype)initWithMenu:(OMNMenu *)menu cellDelegate:(id<OMNMenuProductWithRecommedtationsCellDelegate>)cellDelegate headerDelegate:(id<OMNMenuCategoryHeaderViewDelegate>)headerDelegate {
  self = [super init];
  if (self) {
    
    _menu = menu;
    _cellDelegate = cellDelegate;
    _headerDelegate = headerDelegate;
    
  }
  return self;
}

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [OMNMenuProductWithRecommendationsCellItem registerCellForTableView:tableView];
  [OMNMenuCategorySectionItem registerHeaderFooterViewForTableView:tableView];
  [OMNMenuCategoryDelimiterCellItem registerCellForTableView:tableView];
  [OMNMenuProductsDelimiterCellItem registerCellForTableView:tableView];
  
}

- (NSArray *)categories {
  
  if (_categories) {
    return _categories;
  }
  
  NSMutableArray *menuCategorySectionItems = [NSMutableArray array];
  
  [_menu.categories enumerateObjectsUsingBlock:^(OMNMenuCategory *menuCategory, NSUInteger idx, BOOL *stop) {
    
    OMNMenuCategorySectionItem *parent = [[OMNMenuCategorySectionItem alloc] initWithMenuCategory:menuCategory];
    [menuCategorySectionItems addObject:parent];
    
    NSArray *children = [menuCategory.children bk_map:^id(OMNMenuCategory *childCategory) {
      
      OMNMenuCategorySectionItem *child = [[OMNMenuCategorySectionItem alloc] initWithMenuCategory:childCategory];
      child.parent = parent;
      return child;
      
    }];
    parent.children = children;
    [menuCategorySectionItems addObjectsFromArray:children];
    
  }];
  
  _categories = [menuCategorySectionItems copy];
  
  return _categories;
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return self.categories.count;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.categories[section];
  return menuCategorySectionItem.rowItems.count;

}

- (id)listItemAtIndexPath:(NSIndexPath *)indexPath {
  
  id listItem = nil;
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.categories[indexPath.section];
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
  
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.categories[section];
  OMNMenuCategoryHeaderView *menuCategoryHeaderView = [menuCategorySectionItem headerViewForTableView:tableView];
  menuCategoryHeaderView.delegate = _headerDelegate;
  return menuCategoryHeaderView;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  OMNMenuCategorySectionItem *menuCategorySectionItem = self.categories[section];
  
  if (menuCategorySectionItem.menuCategory.level > 0 &&
      !menuCategorySectionItem.parent.entered) {
    
    return 0.0f;
    
  }
  
  CGFloat heightForHeader = 44.0f;
  return heightForHeader;
  
}

@end
