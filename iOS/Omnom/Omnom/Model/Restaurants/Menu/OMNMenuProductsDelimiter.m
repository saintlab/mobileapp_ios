//
//  OMNMenuProductsDelimiter.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductsDelimiter.h"
#import "OMNMenuProductsDelimiterCell.h"
#import <OMNStyler.h>

@implementation OMNMenuProductsDelimiter

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.color = [colorWithHexString(@"000000") colorWithAlphaComponent:0.2f];
    
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  return 2.0f;
  
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
