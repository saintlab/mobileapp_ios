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

@implementation OMNMenuProductWithRecommedtations {
  
  OMNMenuProduct *_menuProduct;
  OMNMenuProductWithRecommedtationsModel *_model;
  
}

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products {
  self = [super init];
  if (self) {
    
    _menuProduct = menuProduct;
    _model = [[OMNMenuProductWithRecommedtationsModel alloc] initWithMenuProduct:menuProduct products:products];
    
  }
  return self;
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
