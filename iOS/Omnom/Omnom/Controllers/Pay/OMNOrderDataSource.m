//
//  GPaymentVCDataSource.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderDataSource.h"
#import "OMNPaymentFooterView.h"
#import "OMNOrderItemCell.h"
#import "OMNGuestView.h"

@interface OMNOrderDataSource ()

@end

@implementation OMNOrderDataSource

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNOrderItemCell class] forCellReuseIdentifier:@"OMNOrderItemCell"];
  [tableView registerClass:[OMNGuestView class] forHeaderFooterViewReuseIdentifier:OMNGuestViewIdentifier];
  
}

- (NSIndexPath *)lastIndexPath {
  
  NSIndexPath *lastIndexPath = nil;
  if (_order.guests.count) {
    
    NSInteger section = _order.guests.count - 1;
    OMNGuest *guest = _order.guests[section];
    if (guest.items.count) {
      
      NSInteger row = guest.items.count - 1;
      return [NSIndexPath indexPathForRow:row inSection:section];
      
    }
    
  }
  
  return lastIndexPath;
  
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
  orderItemCell.fadeNonSelectedItems = self.fadeNonSelectedItems;
  
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
  
  [_order changeOrderItemSelection:orderItem];
  
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  
  if (self.didSelectBlock) {
    
    self.didSelectBlock(tableView, indexPath);
    
  }
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  const CGFloat triggerDistance = 60.0f;
  CGFloat offset = scrollView.contentOffset.y - MAX(0.0f, scrollView.contentSize.height - CGRectGetHeight(scrollView.frame)) - scrollView.contentInset.bottom;

  if (scrollView.dragging &&
      self.didScrollToTopBlock &&
      offset > triggerDistance) {
    
    self.didScrollToTopBlock();
    
  }
  
}

@end
