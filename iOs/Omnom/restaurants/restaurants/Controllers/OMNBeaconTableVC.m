//
//  OMNBeaconTableVC.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconTableVC.h"
#import "GBeaconForegroundManager.h"
#import "OMNDecodeBeacon.h"
#import "OMNRestaurantMenuVC.h"

@interface OMNBeaconTableVC ()

@property (nonatomic, strong) NSArray *decodeBeacons;

@end

@implementation OMNBeaconTableVC

- (void)dealloc
{
  [[GBeaconForegroundManager manager] stopMonitoring];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
  self = [super initWithStyle:UITableViewStylePlain];
  if (self)
  {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[GBeaconForegroundManager manager] startMonitoring];
  
  
  UILabel *label = [[UILabel alloc] init];
  label.text = @"searching for beacons...";
  [label sizeToFit];
  label.center = self.view.center;
  [self.view addSubview:label];
}

- (void)updateWithBeacons:(NSArray *)beacons {
  
  self.decodeBeacons = beacons;
  
  if (self.decodeBeacons.count > 1)
  {
    [self.tableView reloadData];
  }
  else if (self.decodeBeacons.count == 1)
  {
//    OMNDecodeBeacon *decodeBeacon = [self.decodeBeacons firstObject];
//    GRestaurantMenuVC *restaurantMenuVC = [[GRestaurantMenuVC alloc] initWithRestaurant:decodeBeacon.restaurant table:decodeBeacon.table];
//    [self.navigationController setViewControllers:@[restaurantMenuVC] animated:YES];
  }
  else
  {
  }
  
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.decodeBeacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIndefier = @"cellIndefier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndefier forIndexPath:indexPath];
  if (nil == cell)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndefier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//  OMNDecodeBeacon *decodeBeacon = self.decodeBeacons[indexPath.row];
//  cell.textLabel.text = decodeBeacon.restaurant.title;
}

@end
