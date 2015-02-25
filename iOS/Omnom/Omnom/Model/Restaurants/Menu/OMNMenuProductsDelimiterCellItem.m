//
//  OMNMenuProductsDelimiter.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductsDelimiterCellItem.h"
#import "OMNMenuProductsDelimiterCell.h"
#import <OMNStyler.h>

@implementation OMNMenuProductsDelimiterCellItem

@synthesize hidden=_hidden;

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  return (self.selected) ? (20.0f) : (2.0f);
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductsDelimiterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductsDelimiterCell class])];
  cell.menuProductsDelimiter = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuProductsDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductsDelimiterCell class])];
  
}

@end
