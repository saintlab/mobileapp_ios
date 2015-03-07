//
//  OMNPreorderActionCellItem.m
//  omnom
//
//  Created by tea on 25.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderActionCellItem.h"
#import "OMNPreorderActionCell.h"

@implementation OMNPreorderActionCellItem

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  return 140.0f;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNPreorderActionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNPreorderActionCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNPreorderActionCell class] forCellReuseIdentifier:NSStringFromClass([OMNPreorderActionCell class])];
  
}

@end
