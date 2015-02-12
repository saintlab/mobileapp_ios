//
//  OMNMenuProductExtended.m
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductExtended.h"
#import "OMNMenuProductExtendedView.h"
#import "OMNMenuProductExtendedCell.h"

@implementation OMNMenuProductExtended {
  
  OMNMenuProduct *_menuProduct;
  
}

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct {
  self = [super init];
  if (self) {
    
    _menuProduct = menuProduct;
    
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  static OMNMenuProductExtendedView *menuProductExtendedView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    menuProductExtendedView = [[OMNMenuProductExtendedView alloc] initWithFrame:tableView.bounds];
  });
  
  menuProductExtendedView.bounds = tableView.bounds;
  menuProductExtendedView.menuProduct = _menuProduct;
  [menuProductExtendedView setNeedsLayout];
  [menuProductExtendedView layoutIfNeeded];
  
  CGFloat height = [menuProductExtendedView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductExtendedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductExtendedCell class])];
  cell.menuProduct = _menuProduct;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuProductExtendedCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductExtendedCell class])];
  
}

@end
