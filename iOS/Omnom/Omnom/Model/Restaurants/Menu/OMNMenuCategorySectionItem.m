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
#import <BlocksKit.h>
#import "OMNMenuCategoryHeaderView.h"

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

- (NSArray *)rowItems {

  if (!self.selected) {
    return @[];
  }
  
  if (_rowItems) {
    return _rowItems;
  }
  
  NSMutableArray *rowItems = [NSMutableArray array];
  
  OMNMenuProductsDelimiterCellItem *firstDelimiter = [[OMNMenuProductsDelimiterCellItem alloc] init];
  firstDelimiter.type = kMenuProductsDelimiterTypeTransparent;
  [rowItems addObject:firstDelimiter];
  
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
  
  _rowItems = rowItems;
  
  return _rowItems;
  
}

- (void)close {
  
  self.selected = NO;
  self.entered = NO;
  
}

- (BOOL)visible {
  return (self.menuCategory.level == 0 || self.parent.entered);
}

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuCategoryHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([OMNMenuCategoryHeaderView class])];
  [OMNMenuCategoryDelimiterCellItem registerCellForTableView:tableView];
  [OMNMenuProductsDelimiterCellItem registerCellForTableView:tableView];
  
}

- (OMNMenuCategoryHeaderView *)headerViewForTableView:(UITableView *)tableView {
  
  OMNMenuCategoryHeaderView *menuCategoryHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([OMNMenuCategoryHeaderView class])];
  menuCategoryHeaderView.item = self;
  return menuCategoryHeaderView;
  
}

@end
