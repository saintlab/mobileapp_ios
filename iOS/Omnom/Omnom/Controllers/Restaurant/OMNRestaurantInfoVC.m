//
//  OMNRestaurantInfoVC.m
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfoVC.h"
#import "OMNRestaurantInfoCell.h"
#import <AFNetworking.h>
#import "OMNRestaurantInfo.h"
#import "OMNRestaurantFeedItemCell.h"
#import "OMNProductDetailsVC.h"

@interface OMNRestaurantInfoVC ()
<OMNProductDetailsVCDelegate>

@end

@implementation OMNRestaurantInfoVC {
  OMNRestaurantInfo *_restaurantInfo;
  OMNRestaurant *_restaurant;
  UIImageView *_arrowView;
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    _restaurant = restaurant;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  __weak typeof(self)weakSelf = self;
  [_restaurant advertisement:^(OMNRestaurantInfo *restaurantInfo) {
    
    [weakSelf didFinishLoadingRestaurantInfo:restaurantInfo];
    
  } error:^(NSError *error) {
    
    
    
  }];
  
  _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"show_button_icon"]];
  
  UIButton *closeButton = [[UIButton alloc] init];
  [closeButton setImage:[UIImage imageNamed:@"back_button_icon"] forState:UIControlStateNormal];
  [closeButton addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
  [closeButton sizeToFit];
  self.navigationItem.titleView = closeButton;
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_settings_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(userProfileTap)];

  [self.navigationItem setHidesBackButton:YES animated:NO];
  [self.tableView registerClass:[OMNRestaurantInfoCell class] forCellReuseIdentifier:@"InfoCell"];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
  [self.tableView registerClass:[OMNRestaurantFeedItemCell class] forCellReuseIdentifier:@"FeedItemCell"];
  
}

- (void)didFinishLoadingRestaurantInfo:(OMNRestaurantInfo *)restaurantInfo {
  _restaurantInfo = restaurantInfo;
  [self.tableView reloadData];
}

- (void)userProfileTap {
  
}

- (void)closeTap {
  [self.delegate restaurantInfoVCDidFinish:self];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (UITableViewCell *)cellForFeedItem:(OMNFeedItem *)feedItem {
  UITableViewCell *cell = nil;
  NSUInteger index = [_restaurantInfo.feedItems indexOfObject:feedItem];
  if (index != NSNotFound) {
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:2]];
  }
  return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfRows = 0;
  
  switch (section) {
    case 0: {
      numberOfRows = 1;
    } break;
    case 1: {
      numberOfRows = (_restaurantInfo.selected) ? (_restaurantInfo.fullItems.count) : (_restaurantInfo.shortItems.count);
    } break;
    case 2: {
      numberOfRows = _restaurantInfo.feedItems.count;
    } break;
  }
  
  return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat heightForRow = 44.0f;
  switch (indexPath.section) {
    case 0: {
      heightForRow = 50.0f;
    } break;
    case 1: {
      heightForRow = 40.0f;
    } break;
    case 2: {
      heightForRow = 301.0f;
    } break;
  }
  return heightForRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = nil;
  
  switch (indexPath.section) {
    case 0: {
      
      UITableViewCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
      defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
      defaultCell.textLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:30.0f];
      defaultCell.textLabel.text = _restaurantInfo.title;
      defaultCell.accessoryView = _arrowView;
      cell = defaultCell;
      
    } break;
    case 1: {
      
      OMNRestaurantInfoCell *restaurantInfoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
      NSArray *items = (_restaurantInfo.selected) ? (_restaurantInfo.fullItems) : (_restaurantInfo.shortItems);
      OMNRestaurantInfoItem *item = items[indexPath.row];
      [restaurantInfoCell setItem:item];
      cell = restaurantInfoCell;
      
    } break;
    case 2: {
      
      OMNRestaurantFeedItemCell *restaurantFeedInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FeedItemCell" forIndexPath:indexPath];
      id feedItem = _restaurantInfo.feedItems[indexPath.row];
      [restaurantFeedInfoCell setFeedItem:feedItem];
      cell = restaurantFeedInfoCell;
      
    } break;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0: {
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      _restaurantInfo.selected = !_restaurantInfo.selected;
      [UIView animateWithDuration:0.3 animations:^{
        _arrowView.transform = CGAffineTransformMakeRotation((_restaurantInfo.selected) ? (M_PI) : (0));
      }];
      [tableView beginUpdates];
      [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
      [tableView endUpdates];
    } break;
    case 1: {
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } break;
    case 2: {
      
      OMNFeedItem *feedItem = _restaurantInfo.feedItems[indexPath.row];
      OMNProductDetailsVC *productDetailsVC = [[OMNProductDetailsVC alloc] initFeedItem:feedItem];
      productDetailsVC.delegate = self;
      [self.navigationController pushViewController:productDetailsVC animated:YES];
      
    } break;
  }

}

#pragma mark - OMNProductDetailsVCDelegate

- (void)productDetailsVCDidFinish:(OMNProductDetailsVC *)productDetailsVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

@end
