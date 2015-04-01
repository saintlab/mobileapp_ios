//
//  OMNRestaurantAddressCellItem.m
//  omnom
//
//  Created by tea on 01.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantAddressCellItem.h"
#import "OMNRestaurantAddressCell.h"

@implementation OMNRestaurantAddressCellItem

- (instancetype)initWithRestaurantAddress:(OMNRestaurantAddress *)restaurantAddress {
  self = [super init];
  if (self) {
    
    _address = restaurantAddress;
    
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  static OMNRestaurantAddressCell *cell = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    cell = [[OMNRestaurantAddressCell alloc] initWithFrame:tableView.bounds];
    cell.hidden = YES;
  });
  
  cell.bounds = tableView.bounds;
  cell.item = self;
  [cell.contentView setNeedsLayout];
  [cell.contentView layoutIfNeeded];
  
  CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNRestaurantAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNRestaurantAddressCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNRestaurantAddressCell class] forCellReuseIdentifier:NSStringFromClass([OMNRestaurantAddressCell class])];
  
}

@end
