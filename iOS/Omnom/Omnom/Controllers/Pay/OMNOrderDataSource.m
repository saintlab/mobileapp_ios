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

@interface OMNOrderDataSource ()

@end

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
  
}

- (OMNOrderItem *)orderItemAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNOrderItem *orderItem = nil;
  
  if (indexPath.section < _order.guests.count) {
    
    OMNGuest *guest = _order.guests[indexPath.section];
    
    if (indexPath.row < guest.items.count) {
      
      orderItem = guest.items[indexPath.row];
      
    }
    
  }
  
  return orderItem;
  
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
