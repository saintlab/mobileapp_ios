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
#import "UIView+omn_autolayout.h"
#import "UIView+frame.h"
#import <OMNStyler.h>
#import "OMNRestaurant+omn_network.h"
#import "UINavigationBar+omn_custom.h"
#import "OMNLocationManager.h"
#import <MFMailComposeViewController+BlocksKit.h>

@interface OMNRestaurantListVC ()

@end

@implementation OMNRestaurantListVC {
  
  UIToolbar *_bottomToolbar;
  OMNSearchRestaurantMediator *_searchRestaurantMediator;
  
}

- (instancetype)initWithMediator:(OMNSearchRestaurantMediator *)searchRestaurantMediator {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    
    _searchRestaurantMediator = searchRestaurantMediator;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  OMNToolbarButton *demoButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"demo_mode_icon_small"] title:NSLocalizedString(@"DEMO_MODE_BUTTON_TITLE", @"Демо-режим")];
  [demoButton addTarget:_searchRestaurantMediator action:@selector(demoModeTap) forControlEvents:UIControlEventTouchUpInside];
  
  _bottomToolbar.items =
  @[
    [UIBarButtonItem omn_flexibleItem],
    [[UIBarButtonItem alloc] initWithCustomView:demoButton],
    [UIBarButtonItem omn_flexibleItem],
    ];
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(refreshOrders) forControlEvents:UIControlEventValueChanged];
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  if (0 == self.restaurants.count) {
    
    [self refreshOrdersIfNeeded];
    
  }
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  [self.navigationController.navigationBar omn_setDefaultBackground];
  
  [self.navigationItem setRightBarButtonItem:[UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"user_settings_icon"] color:[UIColor blackColor] target:_searchRestaurantMediator action:@selector(showUserProfile)] animated:YES];
  OMNToolbarButton *qrButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"qr-icon-small"] title:NSLocalizedString(@"SCAN_QR_BUTTON_TITLE", @"Сканировать QR")];
  [qrButton addTarget:_searchRestaurantMediator action:@selector(scanTableQrTap) forControlEvents:UIControlEventTouchUpInside];
  [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:qrButton] animated:YES];

  __weak typeof(self)weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
  
    [weakSelf updateBottomToolbar];
    
  });
  
}

- (void)userFeedbackTap {

  if ([MFMailComposeViewController canSendMail]) {
    
    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
    [composeViewController setToRecipients:@[@"team@omnom.menu"]];
    [composeViewController setSubject:NSLocalizedString(@"FEEDBACK_MAIL_SUBJECT_RESTAURANTS", @"Напишите нам")];
    
    [composeViewController bk_setCompletionBlock:^(MFMailComposeViewController *mailComposeViewController, MFMailComposeResult result, NSError *error) {
      
      [mailComposeViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
      
    }];
    [self presentViewController:composeViewController animated:YES completion:nil];
    
  }
  else {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:team@omnom.menu"]];
    
  }
  
}

- (void)refreshOrdersIfNeeded {
  
  if (self.isViewLoaded &&
      !self.refreshControl.refreshing) {
    
    [self.refreshControl beginRefreshing];
    [self refreshOrders];
    
  }
  
}

- (void)refreshOrders {
  
  __weak typeof(self)weakSelf = self;
  [[OMNLocationManager sharedManager] getLocation:^(CLLocationCoordinate2D coordinate) {
    
    [OMNRestaurant getRestaurantsForLocation:coordinate withCompletion:^(NSArray *restaurants) {
      
      [weakSelf finishLoadingRestaurants:restaurants];
      
    } failure:^(OMNError *error) {
      
      [weakSelf.refreshControl endRefreshing];
      
    }];
    
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
      [_searchRestaurantMediator showCardForRestaurant:restaurant];
      
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

- (void)omn_setup {
  
  _bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, [OMNStyler styler].bottomToolbarHeight.floatValue)];
  [_bottomToolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
  [_bottomToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
  _bottomToolbar.backgroundColor = [OMNStyler styler].toolbarColor;
  [self.tableView addSubview:_bottomToolbar];
  
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  self.tableView.contentInset = insets;
  self.tableView.scrollIndicatorInsets = insets;
  
}

@end
