//
//  OMNMenuCategoryModel.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategoryModel.h"
#import "OMNMenuProductCell.h"
#import "OMNMenuCategory+cell.h"
#import "OMNMenuProductRecommendationsDelimiterCell.h"
#import "OMNMenuProductsDelimiterCell.h"
#import "OMNMenuCategoryHeaderView.h"

@interface OMNMenuCategoryModel ()
<OMNMenuProductWithRecommedtationsCellDelegate>

@end

@implementation OMNMenuCategoryModel

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory {
  self = [super init];
  if (self) {
    
    _menuCategory = menuCategory;
    
  }
  return self;
}

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
  [tableView registerClass:[OMNMenuCategoryDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuCategoryDelimiterCell class])];
  [tableView registerClass:[OMNMenuProductsDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductsDelimiterCell class])];
  [tableView registerClass:[OMNMenuProductWithRecommedtationsCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductWithRecommedtationsCell class])];
  [tableView registerClass:[OMNMenuCategoryHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([OMNMenuCategoryHeaderView class])];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return _menuCategory.children.count;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  OMNMenuCategory *menuCategory = _menuCategory.children[section];
  return menuCategory.listItems.count;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNMenuCategory *menuCategory = _menuCategory.children[indexPath.section];
  id listItem = menuCategory.listItems[indexPath.row];
  if ([listItem conformsToProtocol:@protocol(OMNMenuCellItemProtocol)]) {
    
    UITableViewCell *cell = [listItem cellForTableView:tableView];
    
    if ([cell isKindOfClass:[OMNMenuProductWithRecommedtationsCell class]]) {
      
      OMNMenuProductWithRecommedtationsCell *productWithRecommedtationsCell = (OMNMenuProductWithRecommedtationsCell *)cell;
      productWithRecommedtationsCell.delegate = self;
      
    }
    
    return cell;
    
  }
  else {
    
    return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
  }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNMenuCategory *menuCategory = _menuCategory.children[indexPath.section];
  id listItem = menuCategory.listItems[indexPath.row];
  if ([listItem conformsToProtocol:@protocol(OMNMenuCellItemProtocol)]) {
    
    return [listItem heightForTableView:tableView];
    
  }
  return 100.0f;
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  OMNMenuCategoryHeaderView *menuCategoryHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([OMNMenuCategoryHeaderView class])];
  OMNMenuCategory *menuCategory = _menuCategory.children[section];
  menuCategoryHeaderView.menuCategory = menuCategory;
  return menuCategoryHeaderView;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  return 45.0f;
  
}

#pragma mark - OMNMenuProductWithRecommedtationsCellDelegate

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell didSelectMenuProduct:(OMNMenuProduct *)menuProduct {
 
  [self.delegate menuProductWithRecommedtationsCell:menuProductWithRecommedtationsCell didSelectMenuProduct:menuProduct];
  
}

@end
