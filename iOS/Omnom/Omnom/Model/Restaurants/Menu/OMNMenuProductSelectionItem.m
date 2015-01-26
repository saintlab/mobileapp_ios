//
//  OMNMenuProductSelectionItem.m
//  omnom
//
//  Created by tea on 26.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductSelectionItem.h"
#import "OMNMenuProductView.h"
#import "OMNMenuProductCell.h"

@implementation OMNMenuProductSelectionItem

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct {
  self = [super init];
  if (self) {
    
    _menuProduct = menuProduct;
    
  }
  return self;
}
//
//- (BOOL)showRecommendations {
//  
//  BOOL showRecommendations =
//  (self.selected &&
//   self.menuProduct.quantity > 0.0);
//  
//  return showRecommendations;
//  
//}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  if (self.parent &&
      !self.parent.showRecommendations) {
    
    return 0.0f;
    
  }
  
  static OMNMenuProductView *menuProductView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    menuProductView = [[OMNMenuProductView alloc] init];
  });
  
  menuProductView.menuProductSelectionItem = self;
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
  cell.menuProductSelectionItem = self;
  return cell;
  
}

@end
