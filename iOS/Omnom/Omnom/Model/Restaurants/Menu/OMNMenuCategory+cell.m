//
//  OMNMenuCategory+cell.m
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategory+cell.h"
#import "OMNMenuCategoryDelimiterCell.h"

@implementation OMNMenuCategory (cell)

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  if (self.calculationHeight > 0.0f) {
    return self.calculationHeight;
  }
  
  static OMNMenuCategoryDelimiterView *menuCategoryDelimiterView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    menuCategoryDelimiterView = [[OMNMenuCategoryDelimiterView alloc] initWithFrame:tableView.bounds];
  });
  
  menuCategoryDelimiterView.bounds = tableView.bounds;
  menuCategoryDelimiterView.menuCategory = self;
  [menuCategoryDelimiterView setNeedsLayout];
  [menuCategoryDelimiterView layoutIfNeeded];
  
  CGFloat height = [menuCategoryDelimiterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  self.calculationHeight = height;
  
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuCategoryDelimiterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMNMenuCategoryDelimiterCell"];
  cell.menuCategory = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuCategoryDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuCategoryDelimiterCell class])];
  
}

@end
