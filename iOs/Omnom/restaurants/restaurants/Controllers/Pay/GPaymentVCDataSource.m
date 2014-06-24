//
//  GPaymentVCDataSource.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GPaymentVCDataSource.h"
#import "OMNPaymentFooterView.h"
#import "OMNOrder.h"
#import "OMNConstants.h"
#import "OMNOrderCell.h"
#import "OMNAssetManager.h"

@implementation GPaymentVCDataSource {
  OMNOrder *_order;
}

- (instancetype)initWithOrder:(OMNOrder *)order {
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
  
  UITableViewCell *returnCell = nil;
  
  switch (indexPath.section) {
    case 0: {
      
      static NSString * const orderCellIdentifier = @"orderCellIdentifier";
      OMNOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
      if (nil == cell) {
        cell = [[OMNOrderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:orderCellIdentifier];
      }

      OMNOrderItem *orderItem = _order.items[indexPath.row];
      cell.orderItem = orderItem;
      if (orderItem.selected) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
      }
      else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
      }
      
      returnCell = cell;
    } break;
    case 1: {
      
      static NSString * const cellIdentifier = @"cellIdentifier";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [OMNAssetManager manager].splitCellFont;
        cell.detailTextLabel.font = [OMNAssetManager manager].splitCellFont;
      }
      
      cell.textLabel.text = NSLocalizedString(@"Total", nil);
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", _order.total];
      cell.imageView.image = nil;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      returnCell = cell;
    } break;
  }
  
  return returnCell;
}

@end
