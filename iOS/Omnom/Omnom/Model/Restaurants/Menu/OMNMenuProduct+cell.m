//
//  OMNMenuItem+OMNMenuItem_cell.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProduct+cell.h"
#import "OMNMenuProductCell.h"

@implementation OMNMenuProduct (cell)

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  static OMNMenuProductCell *cell = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    cell = [[OMNMenuProductCell alloc] init];
  });
  
  cell.menuItem = self;

  cell.bounds = tableView.bounds;//CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
  [cell setNeedsLayout];
  [cell layoutIfNeeded];
  
  CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMNMenuProductCell"];
  cell.menuItem = self;
  return cell;
  
}

@end
