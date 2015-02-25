//
//  OMNMenuCategorySectionItem.m
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategorySectionItem.h"
#import "OMNMenuProductWithRecommendationsCellItem.h"
#import "OMNMenuCategoryDelimiterCellItem.h"
#import "OMNMenuProductsDelimiterCellItem.h"

@implementation OMNMenuCategorySectionItem {
  
  NSMutableArray *_rowItems;
  
}

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory {
  self = [super init];
  if (self) {
    
    _menuCategory = menuCategory;

  }
  return self;
}

- (void)setSelected:(BOOL)selected {
  
  if (_selected == selected) {
    return;
  }
  _selected = selected;
  [self.rowItems enumerateObjectsUsingBlock:^(id<OMNMenuTableCellItemProtocol> obj, NSUInteger idx, BOOL *stop) {
    
    [obj setHidden:!selected];
    
  }];
  
}

- (NSArray *)rowItems {
  
  if (!self.selected) {
    return @[];
  }
  
  if (_rowItems) {
    return _rowItems;
  }
  
  NSMutableArray *rowItems = [NSMutableArray array];
  
  NSInteger productsCount = _menuCategory.products.count;
  [_menuCategory.products enumerateObjectsUsingBlock:^(NSString *menuProductID, NSUInteger idx, BOOL *stop) {
    
    OMNMenuProduct *product = _menuCategory.allProducts[menuProductID];
    OMNMenuProductWithRecommendationsCellItem *cellItem = [[OMNMenuProductWithRecommendationsCellItem alloc] initWithMenuProduct:product products:_menuCategory.allProducts];
    [rowItems addObject:cellItem];
    
    OMNMenuProductsDelimiterCellItem *delimiter = [[OMNMenuProductsDelimiterCellItem alloc] init];
    delimiter.type = (idx < productsCount - 1) ? (kMenuProductsDelimiterTypeGray) : (kMenuProductsDelimiterTypeNone);
    cellItem.bottomDelimiter = delimiter;
    [rowItems addObject:delimiter];
    
  }];
  
  if (_menuCategory.level > 0) {
    
    [_menuCategory.children enumerateObjectsUsingBlock:^(OMNMenuCategory *menuCategory, NSUInteger idx, BOOL *stop) {

      [rowItems addObject:[[OMNMenuCategoryDelimiterCellItem alloc] initWithMenuCategory:menuCategory]];
      OMNMenuCategorySectionItem *menuCategorySectionItem = [[OMNMenuCategorySectionItem alloc] initWithMenuCategory:menuCategory];
      menuCategorySectionItem.selected = YES;
      [rowItems addObjectsFromArray:menuCategorySectionItem.rowItems];
      
    }];
    
  }
  
  _rowItems = rowItems;
  
  return _rowItems;
  
}

+ (void)registerHeaderFooterViewForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuCategoryHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([OMNMenuCategoryHeaderView class])];
  [OMNMenuCategoryDelimiterCellItem registerCellForTableView:tableView];
  [OMNMenuProductsDelimiterCellItem registerCellForTableView:tableView];
  
}

- (OMNMenuCategoryHeaderView *)headerViewForTableView:(UITableView *)tableView {
  
  OMNMenuCategoryHeaderView *menuCategoryHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([OMNMenuCategoryHeaderView class])];
  menuCategoryHeaderView.menuCategorySectionItem = self;
  return menuCategoryHeaderView;
  
}

@end
