//
//  OMNMenuProductWithRecommedtations.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductWithRecommedtations.h"
#import "OMNMenuProductView.h"
#import "OMNMenuProductWithRecommedtationsCell.h"
#import "OMNMenuProductWithRecommedtationsModel.h"
#import <BlocksKit.h>
#import <OMNStyler.h>
#import "OMNMenuProduct+cell.h"

@implementation OMNMenuProductWithRecommedtations {
  
  OMNMenuProduct *_menuProduct;
  OMNMenuProductWithRecommedtationsModel *_model;
  NSString *_selectedObserverID;
  
}

- (void)dealloc {
  
  if (_selectedObserverID) {
    [_menuProduct bk_removeObserversWithIdentifier:_selectedObserverID];
  }
  
}

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products {
  self = [super init];
  if (self) {
    
    _menuProduct = menuProduct;
    __weak typeof(self)weakSelf = self;
    _selectedObserverID = [_menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(selected)) options:NSKeyValueObservingOptionNew task:^(OMNMenuProduct *mp, NSDictionary *change) {
      
      [weakSelf updateBottomDelimiter];
      
    }];
    _model = [[OMNMenuProductWithRecommedtationsModel alloc] initWithMenuProduct:menuProduct products:products];
    
  }
  return self;
}

- (void)updateBottomDelimiter {
  
  self.bottomDelimetr.type = _menuProduct.bottomDelimiterType;
  
}

- (void)setBottomDelimetr:(OMNMenuProductsDelimiter *)bottomDelimetr {
  
  _bottomDelimetr = bottomDelimetr;
  [self updateBottomDelimiter];
  
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  return [_model totalHeightForTableView:tableView];
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductWithRecommedtationsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductWithRecommedtationsCell class])];
  cell.model = _model;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuProductWithRecommedtationsCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductWithRecommedtationsCell class])];
  
}

@end
