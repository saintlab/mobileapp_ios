//
//  GProdductSelectionVC.m
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNProductSelectionVC.h"
#import "OMNOrderDataSource.h"
#import "OMNOrder.h"

@interface OMNProductSelectionVC ()

@end

@implementation OMNProductSelectionVC {
  OMNOrder *_order;
  OMNOrderDataSource *_dataSource;
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
  
  _dataSource = [[OMNOrderDataSource alloc] initWithOrder:_order];
  [_dataSource registerCellsForTableView:self.tableView];
  
  self.tableView.tableFooterView = [[UIView alloc] init];
  self.tableView.dataSource = _dataSource;
  self.tableView.allowsMultipleSelection = YES;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [_dataSource tableView:tableView heightForRowAtIndexPath:indexPath];
}

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
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
  }
  
}

@end
