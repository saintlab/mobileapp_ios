//
//  OMNMenuProduct+omn_edit.m
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProduct+omn_edit.h"
#import "OMNProductModiferAlertVC.h"

@implementation OMNMenuProduct (omn_edit)

- (void)editMenuProductFromController:(__weak UIViewController *)viewController withCompletion:(dispatch_block_t)completionBlock {
  
  self.editing = YES;
  OMNProductModiferAlertVC *productModiferAlertVC = [[OMNProductModiferAlertVC alloc] initWithMenuProduct:self];
  __weak typeof(self)weakSelf = self;
  productModiferAlertVC.didCloseBlock = ^{
    
    weakSelf.editing = NO;
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
  };
  
  productModiferAlertVC.didSelectOrderBlock = ^{
    
    weakSelf.editing = NO;
    [viewController dismissViewControllerAnimated:YES completion:completionBlock];
    
  };
  [viewController presentViewController:productModiferAlertVC animated:YES completion:nil];
  
}

@end
