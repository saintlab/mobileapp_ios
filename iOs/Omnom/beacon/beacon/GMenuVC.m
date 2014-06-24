//
//  GMenuVC.m
//  beacon
//
//  Created by tea on 05.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GMenuVC.h"
#import "OMNBeacon.h"

@interface GMenuVC ()

@property (nonatomic, strong) NSArray *orders;

@end

@implementation GMenuVC {
  OMNBeacon *_beacon;
}

- (instancetype)initWithBeacon:(OMNBeacon *)beacon {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    _beacon = beacon;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UILabel *label = [[UILabel alloc] init];
  label.text = _beacon.UUIDString;
  [label sizeToFit];
  label.center = self.view.center;
  [self.view addSubview:label];
  
}

- (void)ordersDidFinishLoading:(NSArray *)orders {
  
//  GOrder *order = [[GOrder alloc] init];
//  order.Description = @"some product";
//  
//  self.orders = @[order, order, order];
//  [self.tableView reloadData];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
//  GOrder *order = self.orders[indexPath.row];
//  cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", order.Description, (long)order.amount];
//  cell.detailTextLabel.text = order.notes;
  
  return cell;
}

@end
