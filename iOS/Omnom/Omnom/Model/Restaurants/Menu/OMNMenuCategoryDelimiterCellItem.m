//
//  OMNMenuCategoryCellItem.m
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategoryDelimiterCellItem.h"
#import "OMNMenuCategoryDelimiterCell.h"

@implementation OMNMenuCategoryDelimiterCellItem {
  
  CGFloat _calculationHeight;
  
}

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory {
  self = [super init];
  if (self) {
    
    _menuCategory = menuCategory;
    
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  if (_calculationHeight > 0.0f) {
    return _calculationHeight;
  }
  
  static OMNMenuCategoryDelimiterView *menuCategoryDelimiterView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    menuCategoryDelimiterView = [[OMNMenuCategoryDelimiterView alloc] initWithFrame:tableView.bounds];
    menuCategoryDelimiterView.hidden = YES;
  });
  
  menuCategoryDelimiterView.bounds = tableView.bounds;
  menuCategoryDelimiterView.menuCategory = _menuCategory;
  [menuCategoryDelimiterView setNeedsLayout];
  [menuCategoryDelimiterView layoutIfNeeded];
  
  CGFloat height = [menuCategoryDelimiterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  _calculationHeight = height;
  
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuCategoryDelimiterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMNMenuCategoryDelimiterCell"];
  cell.menuCategory = _menuCategory;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuCategoryDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuCategoryDelimiterCell class])];
  
}

@end
