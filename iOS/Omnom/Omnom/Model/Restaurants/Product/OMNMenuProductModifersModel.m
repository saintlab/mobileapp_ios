//
//  OMNMenuProductModifersModel.m
//  omnom
//
//  Created by tea on 02.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductModifersModel.h"

@implementation OMNMenuProductModifersModel

- (void)setMenuProduct:(OMNMenuProduct *)menuProduct {
  
  _menuProduct = menuProduct;
  
}

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
//  [tableView registerClass:[OMNMenuCategoryDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuCategoryDelimiterCell class])];
//  [tableView registerClass:[OMNMenuProductsDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductsDelimiterCell class])];
//  [tableView registerClass:[OMNMenuProductWithRecommedtationsCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductWithRecommedtationsCell class])];
//  [tableView registerClass:[OMNMenuCategoryHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([OMNMenuCategoryHeaderView class])];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return _menuProduct.modifiers.count;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  OMNMenuProductModiferCategory *category = _menuProduct.modifiers[section];
  return category.list.count + 1;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
  
}


@end
