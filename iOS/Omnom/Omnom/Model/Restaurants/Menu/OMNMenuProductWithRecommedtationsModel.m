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

@interface OMNMenuProductWithRecommedtationsModel ()
<OMNMenuProductCellDelegate>

@end

@implementation OMNMenuProductWithRecommedtationsModel {
 
  NSArray *_model;
  
}

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products {
  self = [super init];
  if (self) {
    
    _menuProduct = menuProduct;
    
    NSMutableArray *recommendations = [NSMutableArray arrayWithCapacity:menuProduct.recommendations.count];
    [menuProduct.recommendations enumerateObjectsUsingBlock:^(id productID, NSUInteger idx, BOOL *stop) {
      
      OMNMenuProduct *recommendationProduct = products[productID];
      [recommendations addObject:recommendationProduct];
      
    }];
    
    _model =
    @[
      @[menuProduct],
      @[[[OMNMenuProductRecommendationsDelimiter alloc] init]],
      recommendations,
      ];
    
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
  [OMNMenuProductRecommendationsDelimiter registerCellForTableView:tableView];
  
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
  
  if (!_menuProduct.selected &&
      indexPath.section != 0) {
    
    return 0.0f;
    
  }
  id item = [self itemAtIndexPath:indexPath];
  if ([item conformsToProtocol:@protocol(OMNMenuCellItemProtocol)]) {
    
    return [item heightForTableView:tableView];
    
  }
  
  return 100.0f;
  
}

#pragma mark - OMNMenuProductCellDelegate

- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell didSelectProduct:(OMNMenuProduct *)menuProduct {
  
  [self.delegate menuProductCell:menuProductCell didSelectProduct:menuProduct];
  
}

@end
