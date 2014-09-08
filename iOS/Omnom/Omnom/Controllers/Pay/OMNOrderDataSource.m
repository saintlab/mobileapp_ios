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
#import "OMNOrderItemCell.h"
#import "OMNOrderTotalCell.h"
#import "OMNUtils.h"

@implementation OMNOrderDataSource

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
    _order = order;
  }
  return self;
}

- (void)registerCellsForTableView:(UITableView *)tableView {
  [tableView registerClass:[OMNOrderItemCell class] forCellReuseIdentifier:@"OMNOrderItemCell"];
  [tableView registerClass:[OMNOrderTotalCell class] forCellReuseIdentifier:@"OMNOrderTotalCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat heightForRow = 0.0f;
  switch (indexPath.section) {
    case 0: {
      heightForRow = 45.0f;
    } break;
    case 1: {
      heightForRow = (_order.paid_amount > 0) ? (70.0f) : (45.0f);
    } break;
  }
  return heightForRow;
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
      numberOfRows = 1;
    } break;
  }
  
  return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = nil;
  
  switch (indexPath.section) {
    case 0: {
  
      OMNOrderItemCell *orderItemCell = [tableView dequeueReusableCellWithIdentifier:@"OMNOrderItemCell"];
      
      OMNOrderItem *orderItem = _order.items[indexPath.row];
      orderItemCell.orderItem = orderItem;
      if (orderItem.selected) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
      }
      else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
      }
      cell = orderItemCell;
      
    } break;
    case 1: {
      
      OMNOrderTotalCell *orderTotalCell = [tableView dequeueReusableCellWithIdentifier:@"OMNOrderTotalCell"];
      orderTotalCell.order = _order;
      cell = orderTotalCell;
      
    } break;
  }
  
  return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  
  return [[UIView alloc] initWithFrame:CGRectZero];
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
  return 0.01f;
  
}

@end
