//
//  GPaymentVCDataSource.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GPaymentVCDataSource.h"
#import "GPaymentFooterView.h"
#import "GOrder.h"
#import "GConstants.h"

@implementation GPaymentVCDataSource {
  GOrder *_order;
}

- (instancetype)initWithOrder:(GOrder *)order {
  self = [super init];
  if (self) {
    _order = order;
  }
  return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfRows = 0;
  switch (section) {
    case 0: {
      numberOfRows = _order.items.count;
    } break;
    case 1: {
      numberOfRows = 1;
    } break;
  }
  
  return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString * const cellIdentifier = @"cellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
  }
  
  switch (indexPath.section) {
    case 0: {
      
      GOrderItem *orderItem = _order.items[indexPath.row];
      cell.textLabel.textColor = [UIColor blackColor];
      
      
      
      cell.textLabel.text = orderItem.name;
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", orderItem.price];
      cell.detailTextLabel.textColor = [UIColor colorWithWhite:127 / 255. alpha:1];
      cell.imageView.image = orderItem.icon;
      cell.selectionStyle = UITableViewCellSelectionStyleBlue;
      
      cell.selectedBackgroundView = [[UIView alloc] init];
      cell.selectedBackgroundView.backgroundColor = kGreenColor;
      
      if (orderItem.selected) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
      }
      else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
      }
      
    } break;
    case 1: {
      
      cell.textLabel.text = NSLocalizedString(@"Total", nil);
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", _order.selectedItemsTotal];
      cell.imageView.image = nil;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } break;
  }
  
  return cell;
}

@end
