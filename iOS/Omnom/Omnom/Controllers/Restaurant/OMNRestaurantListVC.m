//
//  GRestaurantsVC.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantListVC.h"
#import "OMNToolbarButton.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNRestaurantCell.h"
#import "OMNRestaurantListFeedbackCell.h"
#import "UIView+frame.h"
#import <OMNStyler.h>
#import "OMNRestaurant+omn_network.h"
#import "UINavigationBar+omn_custom.h"
#import "OMNLocationManager.h"
#import <MFMailComposeViewController+BlocksKit.h>
#import <BlocksKit.h>

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
  OMNToolbarButton *demoButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"demo_mode_icon_small"] title:kOMN_DEMO_MODE_BUTTON_TITLE];
  [demoButton addTarget:_searchRestaurantMediator action:@selector(demoModeTap) forControlEvents:UIControlEventTouchUpInside];
  
  _bottomToolbar.items =
  @[
    [UIBarButtonItem omn_flexibleItem],
    [[UIBarButtonItem alloc] initWithCustomView:demoButton],
    [UIBarButtonItem omn_flexibleItem],
    ];
  
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(refreshRestaurants) forControlEvents:UIControlEventValueChanged];
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  if (0 == self.restaurants.count) {
    
    [self refreshRestaurantsIfNeeded];
    
  }
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  [self.navigationController.navigationBar omn_setDefaultBackground];
  
  [self.navigationItem setRightBarButtonItem:[UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"user_settings_icon"] color:[UIColor blackColor] target:_searchRestaurantMediator action:@selector(showSettings)] animated:YES];
  OMNToolbarButton *qrButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"qr-icon-small"] title:kOMN_SCAN_QR_BUTTON_TITLE];
  [qrButton addTarget:_searchRestaurantMediator action:@selector(scanTableQrTap) forControlEvents:UIControlEventTouchUpInside];
  [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:qrButton] animated:YES];
  
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  [self updateBottomToolbar];
  
}

- (void)userFeedbackTap {

  if ([MFMailComposeViewController canSendMail]) {
    
    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
    [composeViewController setToRecipients:@[@"team@omnom.menu"]];
    [composeViewController setSubject:kOMN_FEEDBACK_MAIL_SUBJECT_RESTAURANTS];
    
    [composeViewController bk_setCompletionBlock:^(MFMailComposeViewController *mailComposeViewController, MFMailComposeResult result, NSError *error) {
      
      [mailComposeViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
      
    }];
    [self presentViewController:composeViewController animated:YES completion:nil];
    
  }
  else {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:team@omnom.menu"]];
    
  }
  
}

- (void)refreshRestaurantsIfNeeded {
  
  if (self.isViewLoaded &&
      !self.refreshControl.refreshing) {
    
    [self.refreshControl beginRefreshing];
    [self refreshRestaurants];
    
  }
  
}

- (void)refreshRestaurants {
  
  @weakify(self)
  [[OMNLocationManager sharedManager] getLocation:^(CLLocationCoordinate2D coordinate) {
    
    [OMNRestaurant getRestaurantsForLocation:coordinate withCompletion:^(NSArray *restaurants) {

      @strongify(self)
      [self finishLoadingRestaurants:restaurants];
      
    } failure:^(OMNError *error) {
      
      @strongify(self)
      [self.refreshControl endRefreshing];
      
    }];
    
  }];
  
}

- (void)finishLoadingRestaurants:(NSArray *)restaurants {
  
  [self.refreshControl endRefreshing];
  self.restaurants = [restaurants bk_map:^id(OMNRestaurant *obj) {
    
    return [[OMNRestaurantCellItem alloc] initWithRestaurant:obj];
    
  }];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationFade];
  
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
      
      OMNRestaurantCellItem *item = self.restaurants[indexPath.row];
      cell = [item cellForTableView:tableView];
      
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
      
      OMNRestaurantCellItem *item = self.restaurants[indexPath.row];
      heightForRow = [item heightForTableView:tableView];
      
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

      OMNRestaurantCellItem *item = self.restaurants[indexPath.row];
      [_searchRestaurantMediator showRestaurants:@[item.restaurant]];
      
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
  
  _bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, OMNStyler.bottomToolbarHeight)];
  [_bottomToolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
  [_bottomToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
  _bottomToolbar.backgroundColor = [OMNStyler toolbarColor];
  [self.tableView addSubview:_bottomToolbar];
  
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, OMNStyler.bottomToolbarHeight, 0.0f);
  self.tableView.contentInset = insets;
  self.tableView.scrollIndicatorInsets = insets;
  
  [OMNRestaurantCellItem registerCellForTableView:self.tableView];
  
}

@end
