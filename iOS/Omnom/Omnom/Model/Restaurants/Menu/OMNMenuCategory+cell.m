//
//  OMNMenuCategory+cell.m
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategory+cell.h"

@implementation OMNMenuCategory (cell)

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  return 40.0f;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuCategoryDelimiterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OMNMenuCategoryDelimiterCell"];
  cell.menuCategory = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuCategoryDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuCategoryDelimiterCell class])];
  
}

@end
