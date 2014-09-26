//
//  OMNRestaurantInfoVC.m
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfoVC.h"
#import <AFNetworking.h>
#import "OMNRestaurantInfo.h"
#import "OMNVisitor.h"
#import "OMNFeedItem.h"
#import "OMNAnalitics.h"
#import <OMNStyler.h>

#import "OMNToolbarButton.h"

#import "OMNLabelCell.h"
#import "OMNRestaurantFeedItemCell.h"
#import "OMNRestaurantInfoCell.h"
#import "OMNBottomLabelView.h"

#import "OMNProductDetailsVC.h"

typedef NS_ENUM(NSInteger, RestaurantInfoSection) {
  kRestaurantInfoSectionName = 0,
  kRestaurantInfoSectionAbout,
  kRestaurantInfoSectionMore,
  kRestaurantInfoSectionFeed,
  kRestaurantInfoSectionMax,
};

@interface OMNRestaurantInfoVC ()
<OMNProductDetailsVCDelegate,
UIScrollViewDelegate>

@end

@implementation OMNRestaurantInfoVC {
  OMNRestaurantInfo *_restaurantInfo;
  OMNVisitor *_visitor;
  UIActivityIndicatorView *_spinner;
  BOOL _disableNavigationBarAnimation;
  BOOL _disableSwipeTransition;
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super init];
  if (self) {
    _visitor = visitor;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _disableSwipeTransition = YES;
  _disableNavigationBarAnimation = YES;
  
  OMNToolbarButton *closeButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"back_button_icon"] title:nil];
  [closeButton addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.titleView = closeButton;
  
  _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _spinner.hidesWhenStopped = YES;
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
  
  if (NO == _visitor.restaurant.is_demo) {
    
    [[OMNAnalitics analitics] logEvent:@"promolist_view" parametrs:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_settings_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(userProfileTap)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
  }
  self.automaticallyAdjustsScrollViewInsets = NO;
  [self.navigationItem setHidesBackButton:YES animated:NO];

  self.tableView.tableFooterView = [UIView new];
  [self.tableView registerClass:[OMNRestaurantInfoCell class] forCellReuseIdentifier:@"InfoCell"];
  [self.tableView registerClass:[OMNLabelCell class] forCellReuseIdentifier:@"MoreCell"];
  [self.tableView registerClass:[OMNLabelCell class] forCellReuseIdentifier:@"DefaultCell"];
  [self.tableView registerClass:[OMNRestaurantFeedItemCell class] forCellReuseIdentifier:@"FeedItemCell"];
  self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
  self.tableView.separatorInset = UIEdgeInsetsMake(0.0f, [[[OMNStyler styler] leftOffset] floatValue], 0.0f, 0.0f);
}

- (void)didFinishLoadingRestaurantInfo:(OMNRestaurantInfo *)restaurantInfo {
  [_spinner stopAnimating];
  _restaurantInfo = restaurantInfo;
  [self.tableView reloadData];
}

- (void)didFail {
  [_spinner stopAnimating];
}

- (void)userProfileTap {
  [self.delegate restaurantInfoVCShowUserInfo:self];
}

- (void)closeTap {
  _disableSwipeTransition = YES;
  [self.delegate restaurantInfoVCDidFinish:self];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (!_restaurantInfo) {
    __weak typeof(self)weakSelf = self;
    [_spinner startAnimating];
    [_visitor.restaurant advertisement:^(OMNRestaurantInfo *restaurantInfo) {
      
      [weakSelf didFinishLoadingRestaurantInfo:restaurantInfo];
      
    } error:^(NSError *error) {
      
      [weakSelf didFail];
      
    }];
  }
  
  _disableNavigationBarAnimation = NO;
  [self updateNavigationBarLayer];

}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  _disableSwipeTransition = NO;
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  _disableNavigationBarAnimation = YES;
  _disableSwipeTransition = YES;
  
  CALayer *navigationBarLayer = self.navigationController.navigationBar.layer;
  navigationBarLayer.transform = CATransform3DIdentity;
  navigationBarLayer.opacity = 0.0f;
  [UIView animateWithDuration:0.3 animations:^{
    navigationBarLayer.opacity = 1.0f;
  }];
}

- (UITableViewCell *)cellForFeedItem:(OMNFeedItem *)feedItem {
  UITableViewCell *cell = nil;
  NSUInteger index = [_restaurantInfo.feedItems indexOfObject:feedItem];
  if (index != NSNotFound) {
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:kRestaurantInfoSectionFeed]];
  }
  return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return kRestaurantInfoSectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  NSInteger numberOfRows = 0;
  switch ((RestaurantInfoSection)section) {
    case kRestaurantInfoSectionName: {
      numberOfRows = 1;
    } break;
    case kRestaurantInfoSectionAbout: {
      numberOfRows = (_restaurantInfo.selected) ? (_restaurantInfo.fullItems.count) : (_restaurantInfo.shortItems.count);
    } break;
    case kRestaurantInfoSectionMore: {
      numberOfRows = (_restaurantInfo.selected) ? (0) : (1);
    } break;
    case kRestaurantInfoSectionFeed: {
      numberOfRows = _restaurantInfo.feedItems.count;
    } break;
    case kRestaurantInfoSectionMax: {
    } break;
  }
  
  return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat heightForRow = 44.0f;
  switch ((RestaurantInfoSection)indexPath.section) {
    case kRestaurantInfoSectionName: {
      heightForRow = 50.0f;
    } break;
    case kRestaurantInfoSectionAbout: {
      heightForRow = 40.0f;
    } break;
    case kRestaurantInfoSectionMore: {
      heightForRow = 30.0f;
    } break;
    case kRestaurantInfoSectionFeed: {
      heightForRow = 237.0f;
    } break;
    case kRestaurantInfoSectionMax: {
    } break;
  }
  return heightForRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = nil;
  
  switch ((RestaurantInfoSection)indexPath.section) {
    case kRestaurantInfoSectionName: {
      
      OMNLabelCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
      defaultCell.separatorInset = UIEdgeInsetsMake(0.0f, CGRectGetWidth(self.view.frame), 0.0f, 0.0f);
      defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
      defaultCell.label.font = FuturaOSFOmnomRegular(30.0f);
      defaultCell.label.text = _restaurantInfo.title;
      cell = defaultCell;
      
    } break;
    case kRestaurantInfoSectionAbout: {
      
      OMNRestaurantInfoCell *restaurantInfoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
      NSArray *items = (_restaurantInfo.selected) ? (_restaurantInfo.fullItems) : (_restaurantInfo.shortItems);
      OMNRestaurantInfoItem *item = items[indexPath.row];
      [restaurantInfoCell setItem:item];
      cell = restaurantInfoCell;
      
    } break;
    case kRestaurantInfoSectionMore: {
      
      OMNLabelCell *labelCell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
      labelCell.label.text = NSLocalizedString(@"подробнее о заведении...", nil);
      labelCell.separatorInset = UIEdgeInsetsMake(0.0f, CGRectGetWidth(self.view.frame), 0.0f, 0.0f);
      labelCell.label.textColor = [UIColor colorWithWhite:127.0f/255.0f alpha:1.0f];
      cell = labelCell;
      
    } break;
    case kRestaurantInfoSectionFeed: {
      
      OMNRestaurantFeedItemCell *restaurantFeedInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FeedItemCell" forIndexPath:indexPath];
      OMNFeedItem *feedItem = _restaurantInfo.feedItems[indexPath.row];
      [feedItem logViewEvent];
      [restaurantFeedInfoCell setFeedItem:feedItem];
      cell = restaurantFeedInfoCell;
      
    } break;
    case kRestaurantInfoSectionMax: {
    } break;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch ((RestaurantInfoSection)indexPath.section) {
    case kRestaurantInfoSectionAbout: {
      
      NSArray *items = (_restaurantInfo.selected) ? (_restaurantInfo.fullItems) : (_restaurantInfo.shortItems);
      OMNRestaurantInfoItem *item = items[indexPath.row];
      [item open];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      
    } break;
    case kRestaurantInfoSectionMore: {
      
      _restaurantInfo.selected = !_restaurantInfo.selected;
      [tableView beginUpdates];
      [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kRestaurantInfoSectionMore]] withRowAnimation:UITableViewRowAnimationFade];
      [tableView reloadSections:[NSIndexSet indexSetWithIndex:kRestaurantInfoSectionAbout] withRowAnimation:UITableViewRowAnimationFade];
      [tableView endUpdates];
      
    } break;
    case kRestaurantInfoSectionFeed: {
      
      OMNFeedItem *feedItem = _restaurantInfo.feedItems[indexPath.row];
      [feedItem logClickEvent];
      OMNProductDetailsVC *productDetailsVC = [[OMNProductDetailsVC alloc] initFeedItem:feedItem];
      productDetailsVC.delegate = self;
      [self.navigationController pushViewController:productDetailsVC animated:YES];
      
    } break;
    case kRestaurantInfoSectionName:
    case kRestaurantInfoSectionMax: {
    } break;
  }

}

#pragma mark - OMNProductDetailsVCDelegate

- (void)productDetailsVCDidFinish:(OMNProductDetailsVC *)productDetailsVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - UIScrollViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *viewForHeader = nil;
  
  switch ((RestaurantInfoSection)section) {
    case kRestaurantInfoSectionFeed: {
      OMNBottomLabelView *bottomLabelView = [[OMNBottomLabelView alloc] init];
      bottomLabelView.label.text = NSLocalizedString(@"Стоит попробовать", nil);
      viewForHeader = bottomLabelView;
    } break;
    case kRestaurantInfoSectionName: {
      viewForHeader = [[UIView alloc] init];
      viewForHeader.backgroundColor = [UIColor clearColor];
    } break;
    default: {
    } break;
  }
  return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  CGFloat heightForHeader = 0.0f;
  
  switch ((RestaurantInfoSection)section) {
    case kRestaurantInfoSectionFeed: {
      heightForHeader = 70.0f;
    } break;
    case kRestaurantInfoSectionName: {
      heightForHeader = 64.0f;
    } break;
    default: {
    } break;
  }
  return heightForHeader;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
  [self updateNavigationBarLayer];
  
  if (_restaurantInfo &&
      scrollView.contentInset.top + scrollView.contentOffset.y < -40.0f &&
      !_disableSwipeTransition) {
    [self closeTap];
  }
  
}

- (void)updateNavigationBarLayer {
  
  if (_disableNavigationBarAnimation) {
    return;
  }
  CALayer *navigationBarLayer = self.navigationController.navigationBar.layer;
  CGFloat deltaOffset = self.tableView.contentOffset.y;
  
  if (deltaOffset > 0.0f) {

    navigationBarLayer.transform = CATransform3DMakeTranslation(0.0f, -deltaOffset - self.tableView.contentInset.top, 0.0f);

  }
  else {
    
    navigationBarLayer.transform = CATransform3DIdentity;
    
  }
  
}

@end
