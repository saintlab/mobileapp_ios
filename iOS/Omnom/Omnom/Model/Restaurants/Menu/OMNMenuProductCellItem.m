//
//  OMNMenuProductCellItem.m
//  omnom
//
//  Created by tea on 20.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductCellItem.h"
#import "OMNMenuProductCell.h"

@implementation OMNMenuProductCellItem {
  
  CGFloat _calculationHeight;
  
}

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct {
  self = [super init];
  if (self) {
    
    _menuProduct = menuProduct;
    
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  if (_calculationHeight > 0.0f) {
    return _calculationHeight;
  }
  
  static OMNMenuProductCell *menuProductCell = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    menuProductCell = [[OMNMenuProductCell alloc] initWithFrame:tableView.bounds];
    menuProductCell.hidden = YES;
  });
  
  menuProductCell.bounds = tableView.bounds;
  menuProductCell.item = self;
  [menuProductCell setNeedsLayout];
  [menuProductCell layoutIfNeeded];
  
  CGFloat height = [menuProductCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  _calculationHeight = height;
  
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuProductCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductCell class])];

}

@end
