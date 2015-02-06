//
//  OMNMenuProductWithRecommedtationsModel.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductWithRecommedtationsModel.h"
#import "OMNMenuProductRecommendationsDelimiter.h"
#import "OMNMenuProduct+cell.h"
#import "OMNMenuProductsDelimiter.h"

@interface OMNMenuProductWithRecommedtationsModel ()
<OMNMenuProductCellDelegate>

@end

@implementation OMNMenuProductWithRecommedtationsModel

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products {
  self = [super init];
  if (self) {
    
    _menuProduct = menuProduct;
    
    _model = [NSMutableArray arrayWithObject:@[_menuProduct]];
    [_model addObjectsFromArray:[menuProduct recommendationListWithProducts:products]];
    
  }
  return self;
}

- (CGFloat)totalHeightForTableView:(UITableView *)tableView {

  __block CGFloat totalHeight = 0.0f;
  if (_menuProduct.selected &&
      _menuProduct.recommendations.count) {

    [_model enumerateObjectsUsingBlock:^(NSArray *modelItems, NSUInteger idx, BOOL *stop) {
      
      [modelItems enumerateObjectsUsingBlock:^(id<OMNMenuCellItemProtocol> item, NSUInteger idx, BOOL *stop) {
        
        if ([item conformsToProtocol:@protocol(OMNMenuCellItemProtocol)]) {
          
          totalHeight += [item heightForTableView:tableView];
          
        }
        
      }];
      
    }];
    
  }
  else {

    totalHeight = [_menuProduct heightForTableView:tableView];
    
  }
  
  return totalHeight;
  
}

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [OMNMenuProduct registerCellForTableView:tableView];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return _model.count;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSArray *modelItems = _model[section];
  NSInteger numberOfRows = modelItems.count;
  return numberOfRows;
  
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  
  NSArray *modelItems = _model[indexPath.section];
  id item = modelItems[indexPath.row];
  return item;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id item = [self itemAtIndexPath:indexPath];
  if ([item conformsToProtocol:@protocol(OMNMenuCellItemProtocol)]) {
    
    UITableViewCell *cell = [item cellForTableView:tableView];
    if ([cell isKindOfClass:[OMNMenuProductCell class]]) {
      
      OMNMenuProductCell *menuProductCell = (OMNMenuProductCell *)cell;
      menuProductCell.delegate = self;
      
    }
    return cell;
    
  }
  else {
    
    return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
  }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id item = [self itemAtIndexPath:indexPath];
  if ([item conformsToProtocol:@protocol(OMNMenuCellItemProtocol)]) {
    
    return [item heightForTableView:tableView];
    
  }
  
  return 100.0f;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id item = [self itemAtIndexPath:indexPath];
  if ([item isKindOfClass:[OMNMenuProduct class]]) {
    
    OMNMenuProduct *menuProduct = (OMNMenuProduct *)item;
    OMNMenuProductCell *cell = (OMNMenuProductCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.delegate menuProductCell:cell didSelectProduct:menuProduct];
    
  }
  
}

#pragma mark - OMNMenuProductCellDelegate

- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell editProduct:(OMNMenuProduct *)menuProduct {
  
  [self.delegate menuProductCell:menuProductCell editProduct:menuProduct];
  
}

- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell didSelectProduct:(OMNMenuProduct *)menuProduct {
  
  
  
}

@end
