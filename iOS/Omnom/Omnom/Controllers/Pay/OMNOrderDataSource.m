//
//  GPaymentVCDataSource.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderDataSource.h"
#import "OMNPaymentFooterView.h"
#import "OMNOrder.h"
#import "OMNConstants.h"
#import "OMNOrderCell.h"
#import "OMNUtils.h"

@implementation OMNOrderDataSource

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
    _order = order;
  }
  return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return (self.showTotalView) ? (2) : (1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfRows = 0;
  switch (section) {
    case 0: {
      numberOfRows = _order.items.count;
    } break;
    case 1: {
      numberOfRows = 2;
    } break;
  }
  
  return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString * const orderCellIdentifier = @"orderCellIdentifier";
  OMNOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
  if (nil == cell) {
    cell = [[OMNOrderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:orderCellIdentifier];
  }
  
  switch (indexPath.section) {
    case 0: {
      
      OMNOrderItem *orderItem = _order.items[indexPath.row];
      cell.orderItem = orderItem;
      if (orderItem.selected) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
      }
      else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
      }
      
    } break;
    case 1: {
      
      
      if (0 == indexPath.row) {
        [cell setTitle:NSLocalizedString(@"Total", nil) subtitle:[OMNUtils moneyStringFromKop:_order.total]];
      }
      else if (1 == indexPath.row) {
        [cell setTitle:NSLocalizedString(@"Заплачено", nil) subtitle:[OMNUtils moneyStringFromKop:_order.paid_amount]];
      }
      
    } break;
  }
  
  return cell;
}

@end
