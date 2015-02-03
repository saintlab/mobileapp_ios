//
//  OMNMenuProductModifersModel.m
//  omnom
//
//  Created by tea on 02.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductModifersModel.h"
#import "OMNMenuModiferCategoryCell.h"
#import "OMNMenuModiferCell.h"

CGFloat kRowHeight = 44.0f;

@implementation OMNMenuProductModifersModel

- (void)setMenuProduct:(OMNMenuProduct *)menuProduct {
  
  _menuProduct = menuProduct;
  
  [_menuProduct.modifiers enumerateObjectsUsingBlock:^(OMNMenuProductModiferCategory *category, NSUInteger idx, BOOL *stop) {
    
    category.selected = NO;
    
  }];
  
}

- (CGFloat)tableViewHeight {
  
  __block NSInteger itemsCount = 0;
  [_menuProduct.modifiers enumerateObjectsUsingBlock:^(OMNMenuProductModiferCategory *category, NSUInteger idx, BOOL *stop) {

    itemsCount++;
    if (category.selected) {
      itemsCount += category.list.count;
    }
    
  }];

  return kRowHeight*MIN(itemsCount, 6);
  
}

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
  [tableView registerClass:[OMNMenuModiferCategoryCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuModiferCategoryCell class])];
  [tableView registerClass:[OMNMenuModiferCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuModiferCell class])];
  
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
  
  OMNMenuProductModiferCategory *category = _menuProduct.modifiers[indexPath.section];
  UITableViewCell *cell = nil;
  
  if (0 == indexPath.row) {
    
    if (kMenuProductModiferCategoryTypeCheckbox == category.type) {
      
      OMNMenuModiferCell *menuModiferCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuModiferCell class]) forIndexPath:indexPath];
      OMNMenuModifer *modifer = _menuProduct.allModifers[category.id];
      menuModiferCell.textLabel.text = modifer.name;
      menuModiferCell.accessoryType = ([_menuProduct.selectedModifers containsObject:modifer.id]) ? (UITableViewCellAccessoryCheckmark) : (UITableViewCellAccessoryNone);
      cell = menuModiferCell;
      
    }
    else {

      OMNMenuModiferCategoryCell *menuModiferCategoryCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuModiferCategoryCell class]) forIndexPath:indexPath];
      [menuModiferCategoryCell setCategory:category];
      cell = menuModiferCategoryCell;
      
    }
    
  }
  else {
    
    OMNMenuModiferCell *menuModiferCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuModiferCell class]) forIndexPath:indexPath];
    NSString *modiferID = category.list[indexPath.row - 1];
    OMNMenuModifer *modifer = _menuProduct.allModifers[modiferID];
    menuModiferCell.textLabel.text = modifer.name;
    menuModiferCell.accessoryType = ([_menuProduct.selectedModifers containsObject:modifer.id]) ? (UITableViewCellAccessoryCheckmark) : (UITableViewCellAccessoryNone);
    cell = menuModiferCell;
    
  }
  cell.clipsToBounds = YES;

  return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CGFloat heightForRow = kRowHeight;
  
  OMNMenuProductModiferCategory *category = _menuProduct.modifiers[indexPath.section];
  
  if (0 != indexPath.row) {
    
    if (kMenuProductModiferCategoryTypeCheckbox != category.type &&
        !category.selected) {
      heightForRow = 0.0f;
    }

  }
  
  return heightForRow;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView beginUpdates];
  OMNMenuProductModiferCategory *category = _menuProduct.modifiers[indexPath.section];
  if (0 == indexPath.row) {
    
    if (kMenuProductModiferCategoryTypeCheckbox == category.type) {
      
      if ([_menuProduct.selectedModifers containsObject:category.id]) {
        [_menuProduct.selectedModifers removeObject:category.id];
      }
      else {
        [_menuProduct.selectedModifers addObject:category.id];
      }
      
      
    }
    else {
      
      category.selected = !category.selected;

    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
  }
  else {

    NSString *modiferID = category.list[indexPath.row - 1];
    if (kMenuProductModiferCategoryTypeSelect == category.type) {
      
      [_menuProduct.selectedModifers minusSet:[NSSet setWithArray:category.list]];
      [_menuProduct.selectedModifers addObject:modiferID];
      
    }
    else if (kMenuProductModiferCategoryTypeMultiselect == category.type) {
    
      if ([_menuProduct.selectedModifers containsObject:modiferID]) {
        [_menuProduct.selectedModifers removeObject:modiferID];
      }
      else {
        [_menuProduct.selectedModifers addObject:modiferID];
      }
      
    }
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [tableView endUpdates];
  
  if (self.didSelectBlock) {
    self.didSelectBlock();
  }
  
}

@end
