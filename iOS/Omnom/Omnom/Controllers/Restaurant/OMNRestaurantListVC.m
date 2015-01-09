//
//  GRestaurantsVC.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantListVC.h"
#import "OMNMenu.h"
#import "OMNToolbarButton.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNRestaurantCell.h"
#import "OMNRestaurantListFeedbackCell.h"
#import "OMNRestaurantCardVC.h"
#import "OMNDemoRestaurantVC.h"
#import "UIView+omn_autolayout.h"
#import "UIView+frame.h"
#import <OMNStyler.h>
#import "OMNRestaurant+omn_network.h"
#import "OMNUserInfoVC.h"
#import "OMNScanTableQRCodeVC.h"
#import "UINavigationBar+omn_custom.h"

@interface OMNRestaurantListVC ()
<OMNDemoRestaurantVCDelegate,
OMNRestaurantCardVCDelegate,
OMNUserInfoVCDelegate,
OMNRestaurantActionsVCDelegate,
OMNScanTableQRCodeVCDelegate>

@end

@implementation OMNRestaurantListVC {
  
  UIToolbar *_bottomToolbar;
  
}

- (instancetype)init {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  
  OMNToolbarButton *demoButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"demo_mode_icon_small"] title:NSLocalizedString(@"DEMO_MODE_BUTTON_TITLE", @"Демо-режим")];
  [demoButton addTarget:self action:@selector(demoModeTap) forControlEvents:UIControlEventTouchUpInside];
  
  _bottomToolbar.items =
  @[
    [UIBarButtonItem omn_flexibleItem],
    [[UIBarButtonItem alloc] initWithCustomView:demoButton],
    [UIBarButtonItem omn_flexibleItem],
    ];
  
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"user_settings_icon"] color:[UIColor blackColor] target:self action:@selector(showUserProfile)];
  OMNToolbarButton *qrButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"qr-icon-small"] title:NSLocalizedString(@"SCAN_QR_BUTTON_TITLE", @"Сканировать QR")];
  [qrButton addTarget:self action:@selector(qrTap) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:qrButton];
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(refreshOrders) forControlEvents:UIControlEventValueChanged];
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  if (0 == self.restaurants.count) {
    
    [self refreshOrders];
    
  }
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  [self.navigationController.navigationBar omn_setDefaultBackground];
  [self updateBottomToolbar];
  
}

- (void)demoModeTap {
  
  OMNDemoRestaurantVC *demoRestaurantVC = [[OMNDemoRestaurantVC alloc] initWithParent:nil];
  demoRestaurantVC.delegate = self;
  [self.navigationController pushViewController:demoRestaurantVC animated:YES];
  
}

- (void)qrTap {
  
  OMNScanTableQRCodeVC *scanTableQRCodeVC = [[OMNScanTableQRCodeVC alloc] init];
  scanTableQRCodeVC.delegate = self;
  [self.navigationController pushViewController:scanTableQRCodeVC animated:YES];
  
}

- (void)showUserProfile {
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] initWithMediator:nil];
  userInfoVC.delegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navigationController.delegate = self.navigationController.delegate;
  [self.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)userFeedbackTap {
#warning userFeedbackTap
}

- (void)showCardForRestaurant:(OMNRestaurant *)restaurant {
  
  OMNRestaurantCardVC *restaurantCardVC = [[OMNRestaurantCardVC alloc] initWithRestaurant:restaurant];
  restaurantCardVC.delegate = self;
  [self.navigationController pushViewController:restaurantCardVC animated:YES];
  
}

- (void)showRestaurant:(OMNRestaurant *)restaurant {
  
  OMNRestaurantActionsVC *restaurantCardVC = [[OMNRestaurantActionsVC alloc] initWithRestaurant:restaurant];
  restaurantCardVC.delegate = self;
  [self.navigationController pushViewController:restaurantCardVC animated:YES];
  
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
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationFade];
  [self updateBottomToolbar];
  
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

      numberOfRows = (self.restaurants) ? (1) : (0);
      
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
  
  CGFloat heightForRow = 0.0f;
  switch (indexPath.section) {
    case 0: {
      
      heightForRow = [OMNRestaurantCell height];
      
    } break;
    case 1: {
      
      heightForRow = [OMNRestaurantListFeedbackCell height];
      
    } break;
  }
  
  return heightForRow;
  
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  switch (indexPath.section) {
    case 0: {

      OMNRestaurant *restaurant = self.restaurants[indexPath.row];
      [self showCardForRestaurant:restaurant];
      
    } break;
    case 1: {
      
      [self userFeedbackTap];
      
    } break;
  }
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  [self updateBottomToolbar];

}

- (void)updateBottomToolbar {
  
  _bottomToolbar.transform = CGAffineTransformMakeTranslation(0.0f, self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame) - CGRectGetHeight(_bottomToolbar.frame));
  
}

#pragma mark - OMNDemoRestaurantVCDelegate

- (void)demoRestaurantVCDidFail:(OMNDemoRestaurantVC *)demoRestaurantVC withError:(OMNError *)error {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)demoRestaurantVCDidFinish:(OMNDemoRestaurantVC *)demoRestaurantVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - OMNRestaurantCardVCDelegate

- (void)restaurantCardVC:(OMNRestaurantCardVC *)restaurantCardVC didSelectRestaurant:(OMNRestaurant *)restaurant {
  
  [self showRestaurant:restaurant];
  
}

- (void)restaurantCardVCDidFinish:(OMNRestaurantCardVC *)restaurantCardVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}


#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

#pragma mark - OMNRestaurantActionsVCDelegate

- (void)restaurantActionsVCDidFinish:(OMNRestaurantActionsVC *)restaurantVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - OMNScanTableQRCodeVCDelegate

- (void)scanTableQRCodeVC:(OMNScanTableQRCodeVC *)scanTableQRCodeVC didFindRestaurant:(OMNRestaurant *)restaurant {
  
  [self showRestaurant:restaurant];
  
}

- (void)scanTableQRCodeVCDidCancel:(OMNScanTableQRCodeVC *)scanTableQRCodeVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)omn_setup {
  
  _bottomToolbar = [UIToolbar omn_autolayoutView];
  [_bottomToolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
  [_bottomToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
  _bottomToolbar.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
  [self.view addSubview:_bottomToolbar];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomToolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomToolbar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bottomToolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:[OMNStyler styler].bottomToolbarHeight.floatValue]];
  
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  self.tableView.contentInset = insets;
  self.tableView.scrollIndicatorInsets = insets;
  
}

@end
