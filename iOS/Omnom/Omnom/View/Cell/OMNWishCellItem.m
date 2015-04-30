//
//  OMNWishCellItem.m
//  omnom
//
//  Created by tea on 29.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWishCellItem.h"
#import "OMNWishCell.h"

@implementation OMNWishCellItem

- (instancetype)initWithOrderItem:(OMNOrderItem *)orderItem {
  self = [super init];
  if (self) {
    _orderItem = orderItem;
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  static OMNWishCell *cell = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    cell = [[OMNWishCell alloc] initWithFrame:tableView.bounds];
    cell.hidden = YES;
  });
  
  cell.bounds = tableView.bounds;
  cell.item = self;
  return [cell omn_compressedHeight];
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNWishCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNWishCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  [tableView registerClass:[OMNWishCell class] forCellReuseIdentifier:NSStringFromClass([OMNWishCell class])];
}

@end
