//
//  OMNOrdersVC.m
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrdersVC.h"
#import "OMNPaymentVC.h"

@interface OMNOrdersVC ()

@end

@implementation OMNOrdersVC {
  NSArray *_orders;
}

- (instancetype)initWithOrders:(NSArray *)orders {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    _orders = orders;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"cellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (nil == cell) {
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
  }

  OMNOrder *order = _orders[indexPath.row];
  cell.textLabel.text = order.created;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  OMNOrder *order = _orders[indexPath.row];
  [self.delegate ordersVC:self didSelectOrder:order];
  
}

@end
