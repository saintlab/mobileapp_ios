//
//  OMNPreorderTotalCellItem.m
//  omnom
//
//  Created by tea on 30.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderTotalCellItem.h"
#import "OMNPreorderTotalCell.h"

@implementation OMNPreorderTotalCellItem

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  return (self.total > 0) ? (45.0f) : (0.0f);
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNPreorderTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNPreorderTotalCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNPreorderTotalCell class] forCellReuseIdentifier:NSStringFromClass([OMNPreorderTotalCell class])];
  
}

@end
