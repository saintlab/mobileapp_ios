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
  
  static OMNMenuProductView *menuProductView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    menuProductView = [[OMNMenuProductView alloc] initWithFrame:tableView.bounds];
    menuProductView.hidden = YES;
  });
  
  menuProductView.bounds = tableView.bounds;
  menuProductView.item = self;
  [menuProductView setNeedsLayout];
  [menuProductView layoutIfNeeded];
  
  CGFloat height = [menuProductView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  _calculationHeight = height;
  
  return height;
  
}

- (BOOL)hasReccomendations {
  
  return (_menuProduct.recommendations.count > 0);
  
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
