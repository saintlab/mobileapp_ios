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
#import "OMNGuestView.h"
#import "OMNOrderTotalView.h"

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
  [tableView registerClass:[OMNGuestView class] forHeaderFooterViewReuseIdentifier:OMNGuestViewIdentifier];
  [tableView registerClass:[OMNOrderTotalView class] forHeaderFooterViewReuseIdentifier:OMNOrderTotalViewIdentifier];
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _order.guests.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  OMNGuest *guest = _order.guests[section];
  NSInteger numberOfRows = guest.items.count;
  return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNOrderItemCell *orderItemCell = [tableView dequeueReusableCellWithIdentifier:@"OMNOrderItemCell"];
  
  OMNGuest *guest = _order.guests[indexPath.section];
  OMNOrderItem *orderItem = guest.items[indexPath.row];
  orderItemCell.orderItem = orderItem;
  if (orderItem.selected) {
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
  }
  else {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
  }
  return orderItemCell;
  
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
  CGFloat heightForFooter = 0.0f;
  if (self.showTotalView &&
      section == _order.guests.count - 1) {

    heightForFooter = (_order.paid.net_amount > 0) ? (70.0f) : (45.0f);
  
  }

  return heightForFooter;
  
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  
  UIView *viewForFooter = nil;
  if (self.showTotalView &&
      section == _order.guests.count - 1) {
    OMNOrderTotalView *orderTotalView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OMNOrderTotalViewIdentifier];
    orderTotalView.order = _order;
    viewForFooter = orderTotalView;
  }
  
  return viewForFooter;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  CGFloat heightForHeader = 0.0f;
  
  if (_order.guests.count > 1) {
    heightForHeader = 35.0f;
  }
  
  return heightForHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  UIView *viewForHeader = nil;
  
  if (_order.guests.count > 1) {

    OMNGuestView *guestView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OMNGuestViewIdentifier];
    OMNGuest *guest = _order.guests[section];
    guestView.guest = guest;
    viewForHeader = guestView;
  }
  
  return viewForHeader;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat heightForRow = 45.0f;
  return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [self updateTableView:tableView atIndexPath:indexPath];
  
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [self updateTableView:tableView atIndexPath:indexPath];
  
}

- (void)updateTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
  
  OMNGuest *guest = _order.guests[indexPath.section];
  OMNOrderItem *orderItem = guest.items[indexPath.row];
  [orderItem changeSelection];
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  
  if (self.didSelectBlock) {
    self.didSelectBlock(tableView, indexPath);
  }
  
}

@end
