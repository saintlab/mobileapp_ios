//
//  OMNMenuProduct+cell.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProduct+cell.h"
#import "OMNMenuProductView.h"
#import "OMNMenuProductCell.h"
#import "OMNPreorderConfirmCell.h"

@implementation OMNMenuProduct (cell)

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  if (self.calculationHeight > 0.0f) {
    return self.calculationHeight;
  }
  
  static OMNMenuProductView *menuProductView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    menuProductView = [[OMNMenuProductView alloc] initWithFrame:tableView.bounds];
  });
  
  menuProductView.bounds = tableView.bounds;
  menuProductView.menuProduct = self;
  [menuProductView setNeedsLayout];
  [menuProductView layoutIfNeeded];
  
  CGFloat height = [menuProductView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  self.calculationHeight = height;
  
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductCell class])];
  cell.menuProduct = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuProductCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductCell class])];
  
}

- (CGFloat)preorderHeightForTableView:(UITableView *)tableView {
  
  static OMNPreorderConfirmView *preorderConfirmView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    preorderConfirmView = [[OMNPreorderConfirmView alloc] initWithFrame:tableView.bounds];
  });
  
  preorderConfirmView.bounds = tableView.bounds;
  preorderConfirmView.menuProduct = self;
  [preorderConfirmView setNeedsLayout];
  [preorderConfirmView layoutIfNeeded];
  
  CGFloat height = [preorderConfirmView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  
  return height;
  
}

@end
