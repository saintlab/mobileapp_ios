//
//  OMNMenuPreorderedCellItem.m
//  omnom
//
//  Created by tea on 25.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderConfirmCellItem.h"
#import "OMNProductModiferAlertVC.h"
#import "OMNPreorderConfirmCell.h"

@implementation OMNPreorderConfirmCellItem {
  
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
  
  static OMNPreorderConfirmCell *preorderConfirmCell = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    preorderConfirmCell = [[OMNPreorderConfirmCell alloc] initWithFrame:tableView.bounds];
    preorderConfirmCell.hidden = YES;
  });
  
  preorderConfirmCell.bounds = tableView.bounds;
  preorderConfirmCell.item = self;
  [preorderConfirmCell setNeedsLayout];
  [preorderConfirmCell layoutIfNeeded];
  
  CGFloat height = [preorderConfirmCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  _calculationHeight = height;
  
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNPreorderConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNPreorderConfirmCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNPreorderConfirmCell class] forCellReuseIdentifier:NSStringFromClass([OMNPreorderConfirmCell class])];
  
}

- (void)editMenuProductFromController:(UIViewController *)viewController withCompletion:(dispatch_block_t)completionBlock {
  
  OMNProductModiferAlertVC *productModiferAlertVC = [[OMNProductModiferAlertVC alloc] initWithMenuProduct:self.menuProduct];
  productModiferAlertVC.didCloseBlock = ^{
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
  };
  
  productModiferAlertVC.didSelectOrderBlock = ^{
    
    [viewController dismissViewControllerAnimated:YES completion:completionBlock];
    
  };
  [viewController presentViewController:productModiferAlertVC animated:YES completion:nil];
  
}

@end
