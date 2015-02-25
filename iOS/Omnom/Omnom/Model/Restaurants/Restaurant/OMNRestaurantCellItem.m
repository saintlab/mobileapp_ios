//
//  OMNRestaurantCellItem.m
//  omnom
//
//  Created by tea on 25.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantCellItem.h"
#import "OMNRestaurantCell.h"

@implementation OMNRestaurantCellItem {
  
  CGFloat _calculationHeight;
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _restaurant = restaurant;
    
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  if (_calculationHeight > 0.0f) {
    return _calculationHeight;
  }
  
  static OMNRestaurantView *restaurantView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    restaurantView = [[OMNRestaurantView alloc] initWithFrame:tableView.bounds];
    restaurantView.hidden = YES;
  });
  
  restaurantView.bounds = tableView.bounds;
  restaurantView.restaurant = self.restaurant;
  [restaurantView setNeedsLayout];
  [restaurantView layoutIfNeeded];
  
  CGFloat height = [restaurantView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  _calculationHeight = height;
  
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNRestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNRestaurantCell class])];
  cell.item = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNRestaurantCell class] forCellReuseIdentifier:NSStringFromClass([OMNRestaurantCell class])];
  
}

@end
