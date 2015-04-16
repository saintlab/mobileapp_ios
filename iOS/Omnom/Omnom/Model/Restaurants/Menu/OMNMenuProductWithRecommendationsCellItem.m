//
//  OMNMenuProductWithRecommendationsCellItem.m
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductWithRecommendationsCellItem.h"
#import "OMNMenuProductWithRecommedtationsCell.h"
#import "OMNMenuProductRecommendationsDelimiterCellItem.h"
#import "OMNMenuProductCell.h"

@implementation OMNMenuProductWithRecommendationsCellItem {
  
  NSMutableArray *_recommendations;
  
}

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products {
  self = [super init];
  if (self) {
    
    _menuProduct = menuProduct;
    self.menuProductCellItem = [[OMNMenuProductCellItem alloc] initWithMenuProduct:menuProduct];
    self.menuProductCellItem.delegate = self;
    NSInteger recommendationsCount = _menuProduct.recommendations.count;
    NSMutableArray *recommendations = [NSMutableArray array];
    if (recommendationsCount > 0) {
      
      [_recommendations addObject:[[OMNMenuProductRecommendationsDelimiterCellItem alloc] init]];
      
      __weak typeof(self)weakSelf = self;
      [_menuProduct.recommendations enumerateObjectsUsingBlock:^(id productID, NSUInteger idx, BOOL *stop) {
        
        OMNMenuProductCellItem *recommendationItem = [[OMNMenuProductCellItem alloc] initWithMenuProduct:products[productID]];
        recommendationItem.delimiterType = (idx < recommendationsCount - 1) ? (kBottomDelimiterTypeLine) : (kBottomDelimiterTypeNone);
        recommendationItem.delegate = weakSelf;
        [recommendations addObject:recommendationItem];

      }];
      
    }
      
      _recommendations = recommendations;
  }
  return self;
}

- (BOOL)showRecommendations {
  return (self.selected && self.menuProduct.showRecommendations);
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  __block CGFloat height = [_menuProductCellItem heightForTableView:tableView];
  
  if ([self showRecommendations]) {
    
    [_recommendations enumerateObjectsUsingBlock:^(id<OMNCellItemProtocol> obj, NSUInteger idx, BOOL *stop) {
      
      if ([obj conformsToProtocol:@protocol(OMNCellItemProtocol)]) {
        height += [obj heightForTableView:tableView];
      }
      
    }];
    
  }

  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductWithRecommedtationsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductWithRecommedtationsCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  [tableView registerClass:[OMNMenuProductWithRecommedtationsCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductWithRecommedtationsCell class])];
}

+ (void)registerProductWithRecommendationsCellForTableView:(UITableView *)tableView {
  
  [OMNMenuProductCellItem registerCellForTableView:tableView];
  [OMNMenuProductRecommendationsDelimiterCellItem registerCellForTableView:tableView];
  
}

- (void)setSelected:(BOOL)selected {
  
  _selected = selected;
  _bottomDelimiter.selected = [self showRecommendations];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSInteger numberOfRows = 0;
  
  switch (section) {
    case 0: {
      numberOfRows = 1;
    } break;
    case 1: {
      numberOfRows = _recommendations.count;
    } break;
  }
  
  return numberOfRows;
  
}

- (id<OMNCellItemProtocol>)itemAtIndexPath:(NSIndexPath *)indexPath {
  
  id item = nil;
  switch (indexPath.section) {
    case 0: {
      item = _menuProductCellItem;
    } break;
    case 1: {
      item = _recommendations[indexPath.row];
    } break;
  }
  return item;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id item = [self itemAtIndexPath:indexPath];
  UITableViewCell *cell = [item cellForTableView:tableView];
  return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id item = [self itemAtIndexPath:indexPath];
  if ([item conformsToProtocol:@protocol(OMNCellItemProtocol)]) {
    
    return [item heightForTableView:tableView];
    
  }
  
  return 100.0f;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id item = [self itemAtIndexPath:indexPath];
  if ([item isKindOfClass:[OMNMenuProductCellItem class]]) {
    
    OMNMenuProductCell *cell = (OMNMenuProductCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.productItemDelegate menuProductCellDidSelect:cell];
    
  }
  
}

#pragma mark - OMNMenuProductCellDelegate

- (void)menuProductCellDidEdit:(OMNMenuProductCell *)menuProductCell {
  [self.productItemDelegate menuProductCellDidEdit:menuProductCell];
}

- (void)menuProductCellDidSelect:(OMNMenuProductCell *)menuProductCell {
  //do nothing
}

@end
