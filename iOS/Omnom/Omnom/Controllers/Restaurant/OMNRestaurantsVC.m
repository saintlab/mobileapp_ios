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
#import "OMNToolbarButton.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNRestaurantCell.h"
#import "OMNRestaurantListFeedbackCell.h"

@interface OMNRestaurantsVC ()

@property (nonatomic, strong) NSArray *restaurants;

@end

@implementation OMNRestaurantsVC {
  
}

- (instancetype)init {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  OMNToolbarButton *demoButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"demo_mode_icon_small"] title:NSLocalizedString(@"Демо-режим", nil)];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:demoButton];
  
  self.navigationItem.rightBarButtonItems =
  @[
    [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"user_settings_icon"] color:[UIColor blackColor] target:self action:@selector(showUserProfile)],
    [UIBarButtonItem omn_fixedItemWithSpace:20.0f],
    [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"qr-icon-small"] color:[UIColor blackColor] target:self action:@selector(qrTap)],
    ];
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(refreshOrders) forControlEvents:UIControlEventValueChanged];
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  [self refreshOrders];
  
}

- (void)qrTap {
  
}

- (void)showUserProfile {
  
}

- (void)userFeedbackTap {
  
}

- (void)refreshOrders {
  
  if (!self.refreshControl.refreshing) {
    [self.refreshControl beginRefreshing];
  }
  
  __weak typeof(self)weakSelf = self;
  [OMNRestaurant getRestaurants:^(NSArray *restaurants) {
    
    [weakSelf finishLoadingRestaurants:restaurants];
    
  } failure:^(OMNError *error) {
    
    [self.refreshControl endRefreshing];
    
  }];
  
}

- (void)finishLoadingRestaurants:(NSArray *)restaurants {
  
  [self.refreshControl endRefreshing];
  self.restaurants = restaurants;
  [self.tableView reloadData];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 2;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSInteger numberOfRows = 0;
  switch (section) {
    case 0: {
      
      numberOfRows = self.restaurants.count;
      
    } break;
    case 1: {

      numberOfRows = 1;
      
    } break;
  }
  
  return numberOfRows;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell *cell = nil;
  
  switch (indexPath.section) {
    case 0: {
      
      OMNRestaurantCell *restaurantCell = [OMNRestaurantCell cellForTableView:tableView];
      OMNRestaurant *restaurant = self.restaurants[indexPath.row];
      restaurantCell.restaurant = restaurant;
      cell = restaurantCell;
      
    } break;
    case 1: {
      
      cell = [OMNRestaurantListFeedbackCell cellForTableView:tableView];
      
    } break;
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CGFloat heightForRow = 44.0f;
  switch (indexPath.section) {
    case 0: {
      
      heightForRow = 242.0f;
      
    } break;
    case 1: {
      
      heightForRow = 114.0f;
      
    } break;
  }
  
  return heightForRow;
  
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  switch (indexPath.section) {
    case 0: {
      
      [self.navigationController pushViewController:[UIViewController new] animated:YES];
      
    } break;
    case 1: {
      
      [self userFeedbackTap];
      
    } break;
  }
  
}

@end
