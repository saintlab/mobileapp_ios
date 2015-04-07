//
//  OMNPreorderActionCellItem.m
//  omnom
//
//  Created by tea on 25.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderActionCellItem.h"
#import "OMNPreorderActionCell.h"

@implementation OMNPreorderActionCellItem

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  static OMNPreorderActionCell *cell = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    cell = [[OMNPreorderActionCell alloc] initWithFrame:tableView.bounds];
    cell.hidden = YES;
  });
  
  cell.bounds = tableView.bounds;
  cell.item = self;
  [cell setNeedsLayout];
  [cell layoutIfNeeded];
  
  CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNPreorderActionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNPreorderActionCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  [tableView registerClass:[OMNPreorderActionCell class] forCellReuseIdentifier:NSStringFromClass([OMNPreorderActionCell class])];
}

@end
