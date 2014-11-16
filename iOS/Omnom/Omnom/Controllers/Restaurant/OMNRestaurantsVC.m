//
//  GRestaurantsVC.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantsVC.h"
#import "OMNRestaurant.h"
#import "OMNMenu.h"

@interface OMNRestaurantsVC ()

@property (nonatomic, strong) NSArray *restaurants;

@end

@implementation OMNRestaurantsVC {
  UIRefreshControl *_refreshControl;
}

- (instancetype)init {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _refreshControl = [[UIRefreshControl alloc] init];
  [_refreshControl addTarget:self action:@selector(refreshOrders) forControlEvents:UIControlEventValueChanged];
  
  self.refreshControl = _refreshControl;
  [self refreshOrders];
  
}

- (void)refreshOrders {
  
  if (!_refreshControl.refreshing) {
    [_refreshControl beginRefreshing];
  }
  
  __weak typeof(self)weakSelf = self;
  [OMNRestaurant getRestaurantList:^(NSArray *restaurants) {
    
    [weakSelf finishLoadingRestaurants:restaurants];
    
  } error:^(NSError *error) {
    
    [_refreshControl endRefreshing];
    
  }];
  
}

- (void)finishLoadingRestaurants:(NSArray *)restaurants {
  [_refreshControl endRefreshing];
  self.restaurants = restaurants;
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.restaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reuseIdentifier = @"reuseIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  OMNRestaurant *restaurant = self.restaurants[indexPath.row];
  cell.textLabel.text = restaurant.title;
  cell.detailTextLabel.text = restaurant.Description;
  
  return cell;
}
 
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
}

@end
