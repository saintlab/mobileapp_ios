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

@implementation OMNMenuCategoryModel {
  
  __weak id<OMNMenuProductWithRecommedtationsCellDelegate> _delegate;
  
}

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory delegate:(__weak id<OMNMenuProductWithRecommedtationsCellDelegate>)delegate {
  self = [super init];
  if (self) {
    
    _menuCategory = menuCategory;
    _delegate = delegate;
    
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
  
  return _menuCategory.children.count + 1;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSInteger numberOfRows = 0;
  if (0 == section) {
    
    numberOfRows = _menuCategory.listItems.count;
    
  }
  else {
    
    OMNMenuCategory *menuCategory = _menuCategory.children[section - 1];
    numberOfRows = menuCategory.listItems.count;
    
  }
  
  return numberOfRows;
  
}

- (id)listItemAtIndexPath:(NSIndexPath *)indexPath {
  
  id listItem = nil;
  if (0 == indexPath.section) {
    
    listItem = _menuCategory.listItems[indexPath.row];
    
  }
  else {
    
    OMNMenuCategory *menuCategory = _menuCategory.children[indexPath.section - 1];
    listItem = menuCategory.listItems[indexPath.row];
    
  }
  
  return listItem;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id listItem = [self listItemAtIndexPath:indexPath];
  if ([listItem conformsToProtocol:@protocol(OMNMenuCellItemProtocol)]) {
    
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
  if ([listItem conformsToProtocol:@protocol(OMNMenuCellItemProtocol)]) {
    
    return [listItem heightForTableView:tableView];
    
  }
  return 100.0f;
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  UIView *viewForHeader = nil;
  if (section > 0) {

    OMNMenuCategoryHeaderView *menuCategoryHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([OMNMenuCategoryHeaderView class])];
    OMNMenuCategory *menuCategory = _menuCategory.children[section];
    menuCategoryHeaderView.menuCategory = menuCategory;
    viewForHeader = menuCategoryHeaderView;
    
  }
  
  return viewForHeader;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  CGFloat heightForHeader = 0.0f;
  if (section > 0) {
    
    heightForHeader = 45.0f;
    
  }
  
  return heightForHeader;
  
}

@end
