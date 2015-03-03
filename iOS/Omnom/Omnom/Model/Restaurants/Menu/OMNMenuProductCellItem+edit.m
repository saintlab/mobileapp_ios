//
//  OMNMenuProductCellItem+edit.m
//  omnom
//
//  Created by tea on 24.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductCellItem+edit.h"
#import "OMNProductModiferAlertVC.h"

@implementation OMNMenuProductCellItem (edit)

- (void)editMenuProductFromController:(__weak UIViewController *)viewController withCompletion:(dispatch_block_t)completionBlock {
  
  self.editing = YES;
  OMNProductModiferAlertVC *productModiferAlertVC = [[OMNProductModiferAlertVC alloc] initWithMenuProduct:self.menuProduct];
  @weakify(self)
  productModiferAlertVC.didCloseBlock = ^{
    
    @strongify(self)
    self.editing = NO;
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
  };
  
  productModiferAlertVC.didSelectOrderBlock = ^{
    
    @strongify(self)
    self.editing = NO;
    [viewController dismissViewControllerAnimated:YES completion:completionBlock];
    
  };
  [viewController presentViewController:productModiferAlertVC animated:YES completion:nil];
  
}

@end
