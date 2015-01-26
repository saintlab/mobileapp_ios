//
//  OMNMenuItem+OMNMenuItem_cell.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProduct+cell.h"
#import "OMNMenuProductView.h"
#import "OMNMenuProductCell.h"

@implementation OMNMenuProduct (cell)

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  static OMNMenuProductView *menuProductView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    menuProductView = [[OMNMenuProductView alloc] init];
  });
  
  menuProductView.menuProduct = self;
  menuProductView.bounds = tableView.bounds;
  [menuProductView setNeedsLayout];
  [menuProductView layoutIfNeeded];
  
  CGFloat height = [menuProductView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMNMenuProductCell"];
  cell.menuProduct = self;
  return cell;
  
}

@end
