//
//  OMNWishStatusCellItem.m
//  omnom
//
//  Created by tea on 29.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWishStatusCellItem.h"
#import "OMNWishStatusCell.h"

@implementation OMNWishStatusCellItem

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  static OMNWishStatusCell *cell = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    cell = [[OMNWishStatusCell alloc] initWithFrame:tableView.bounds];
    cell.hidden = YES;
  });
  
  cell.bounds = tableView.bounds;
  cell.item = self;
  return [cell omn_compressedHeight];
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNWishStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNWishStatusCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  [tableView registerClass:[OMNWishStatusCell class] forCellReuseIdentifier:NSStringFromClass([OMNWishStatusCell class])];
}

@end
