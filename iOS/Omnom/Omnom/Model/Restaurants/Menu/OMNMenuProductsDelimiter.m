//
//  OMNMenuProductsDelimiter.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductsDelimiter.h"
#import "OMNMenuProductsDelimiterCell.h"

@implementation OMNMenuProductsDelimiter

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  return 2.0f;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductsDelimiterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductsDelimiterCell class])];
  return cell;
  
}

@end
