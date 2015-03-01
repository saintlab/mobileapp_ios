//
//  OMNMenuProductFullCellItem.m
//  omnom
//
//  Created by tea on 25.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductFullCellItem.h"
#import "OMNMenuProductFullCell.h"

@implementation OMNMenuProductFullCellItem

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  static OMNMenuProductFullCell *menuProductFullCell = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    menuProductFullCell = [[OMNMenuProductFullCell alloc] initWithFrame:tableView.bounds];
    menuProductFullCell.hidden = YES;
  });
  
  menuProductFullCell.frame = tableView.bounds;
  menuProductFullCell.item = self;
  [menuProductFullCell setNeedsLayout];
  [menuProductFullCell layoutIfNeeded];
  
  CGFloat height = [menuProductFullCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductFullCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductFullCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuProductFullCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductFullCell class])];
  
}

@end
