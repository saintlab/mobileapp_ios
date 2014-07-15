//
//  GProdductSelectionVC.m
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GProdductSelectionVC.h"
#import "GPaymentVCDataSource.h"
#import "OMNOrder.h"

@interface GProdductSelectionVC ()

@end

@implementation GProdductSelectionVC {
  OMNOrder *_order;
  GPaymentVCDataSource *_dataSource;
}


- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
    _order = order;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _dataSource = [[GPaymentVCDataSource alloc] initWithOrder:_order];
  
  self.tableView.allowsMultipleSelection = YES;
  self.tableView.tableFooterView = [[UIView alloc] init];
  self.tableView.dataSource = _dataSource;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self updateTotalValue];
}

- (void)updateTotalValue {

  if ([self.delegate respondsToSelector:@selector(totalDidChange:)]) {
    
    double selectedItemsTotal = [_order selectedItemsTotal];
    [self.delegate totalDidChange:selectedItemsTotal];
    
  }
  
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [self updateTableView:tableView atIndexPath:indexPath];
  
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [self updateTableView:tableView atIndexPath:indexPath];
  
}

- (void)updateTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
  
  if (0 == indexPath.section) {
    
    OMNOrderItem *orderItem = _order.items[indexPath.row];
    [orderItem changeSelection];
    
    [self updateTotalValue];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    
  }
  
}

@end
