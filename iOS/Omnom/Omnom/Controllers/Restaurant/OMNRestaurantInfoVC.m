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
#import "OMNFeedItem.h"
#import "OMNAnalitics.h"
#import <OMNStyler.h>
#import "UIBarButtonItem+omn_custom.h"
#import "OMNRestaurant+omn_network.h"

#import "OMNLabelCell.h"
#import "OMNRestaurantFeedItemCell.h"
#import "OMNRestaurantInfoCell.h"
#import "OMNBottomLabelView.h"

#import "OMNProductDetailsVC.h"

typedef NS_ENUM(NSInteger, RestaurantInfoSection) {
  kRestaurantInfoSectionName = 0,
  kRestaurantInfoSectionDescription,
  kRestaurantInfoSectionAbout,
  kRestaurantInfoSectionFeed,
  kRestaurantInfoSectionMax,
};

@interface OMNRestaurantInfoVC ()
<OMNProductDetailsVCDelegate,
UIScrollViewDelegate,
UIGestureRecognizerDelegate>

@end

@implementation OMNRestaurantInfoVC {

  OMNRestaurant *_restaurant;
  BOOL _disableNavigationBarAnimation;
  BOOL _disableSwipeTransition;
  UIPercentDrivenInteractiveTransition *_percentDrivenInteractiveTransition;
  UIButton *_arrowButton;
  
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
  
  _disableSwipeTransition = YES;
  _disableNavigationBarAnimation = YES;
  
  _arrowButton = [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"back_button_top_icon"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  self.navigationItem.titleView = _arrowButton;
  
  if (!_restaurant.is_demo) {
    
    [[OMNAnalitics analitics] logTargetEvent:@"promolist_view" parametrs:nil];

  }
  self.automaticallyAdjustsScrollViewInsets = NO;

  self.tableView.tableFooterView = [UIView new];
  [self.tableView registerClass:[OMNRestaurantInfoCell class] forCellReuseIdentifier:@"InfoCell"];
  [self.tableView registerClass:[OMNLabelCell class] forCellReuseIdentifier:@"MoreCell"];
  [self.tableView registerClass:[OMNLabelCell class] forCellReuseIdentifier:@"DefaultCell"];
  [self.tableView registerClass:[OMNLabelCell class] forCellReuseIdentifier:@"DescriptionCell"];
  [self.tableView registerClass:[OMNRestaurantFeedItemCell class] forCellReuseIdentifier:@"FeedItemCell"];

  self.tableView.separatorInset = UIEdgeInsetsMake(0.0f, [[[OMNStyler styler] leftOffset] floatValue], 0.0f, 0.0f);
  self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, [[OMNStyler styler] bottomToolbarHeight].floatValue, 0.0f);
  self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64.0f, 0.0f, [[OMNStyler styler] bottomToolbarHeight].floatValue, 0.0f);
  
  [self.tableView.panGestureRecognizer addTarget:self action:@selector(pan:)];
  
}

- (void)startAnimating:(BOOL)start {
  
  if (start) {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:spinner] animated:YES];

  }
  else {
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] animated:YES];
    
  }
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadRestaurantInfoIfNeeded];
  [self.navigationItem setHidesBackButton:YES animated:NO];
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

- (void)loadRestaurantInfoIfNeeded {
 
  if (_restaurant.info) {
    return;
  }
  
  [self startAnimating:YES];
  __weak typeof(self)weakSelf = self;
  [_restaurant advertisement:^(OMNRestaurantInfo *restaurantInfo) {
    
    [weakSelf didFinishLoadingRestaurantInfo:restaurantInfo];
    
  } error:^(NSError *error) {
    
    [weakSelf didFail];
    
  }];
  
}

- (void)pan:(UIPanGestureRecognizer *)panGR {
  
  if (self.tableView.contentOffset.y < -20 &&
      nil == _percentDrivenInteractiveTransition) {
    
    [panGR setTranslation:CGPointZero inView:panGR.view];
    _percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
    [self closeTap];
    
  }
  
  if (_percentDrivenInteractiveTransition) {

    CGPoint translation = [panGR translationInView:panGR.view];
    CGFloat percentage = MAX(0.0f, translation.y / panGR.view.bounds.size.height);
    CGFloat velocity = [panGR velocityInView:panGR.view].y;

    switch (panGR.state) {
      case UIGestureRecognizerStateChanged: {
        
        [_percentDrivenInteractiveTransition updateInteractiveTransition:percentage];
        
      } break;
      case UIGestureRecognizerStateEnded: {
        
        if (percentage > 0.3f ||
            velocity > 100.0f) {
          [_percentDrivenInteractiveTransition finishInteractiveTransition];
        }
        else {
          [_percentDrivenInteractiveTransition cancelInteractiveTransition];
        }
        _percentDrivenInteractiveTransition = nil;
        
      } break;
      case UIGestureRecognizerStateCancelled: {
        
        [_percentDrivenInteractiveTransition cancelInteractiveTransition];
        _percentDrivenInteractiveTransition = nil;
        
      } break;
      default: {
      } break;
    }
    
  }
  
}

- (void)didFinishLoadingRestaurantInfo:(OMNRestaurantInfo *)restaurantInfo {
  
  [self startAnimating:NO];
  [self.tableView reloadData];
  
}

- (void)didFail {
  [self startAnimating:NO];
}

- (void)closeTap {
  
  _disableSwipeTransition = YES;
  [self.delegate restaurantInfoVCDidFinish:self];
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleDefault;
  
}

- (UITableViewCell *)cellForFeedItem:(OMNFeedItem *)feedItem {
  UITableViewCell *cell = nil;
  NSUInteger index = [_restaurant.info.feedItems indexOfObject:feedItem];
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
    case kRestaurantInfoSectionDescription: {
      numberOfRows = (_restaurant.Description.length) ? (1) : (0);
    } break;
    case kRestaurantInfoSectionAbout: {
      numberOfRows = _restaurant.info.fullItems.count;
    } break;
    case kRestaurantInfoSectionFeed: {
      numberOfRows = _restaurant.info.feedItems.count;
    } break;
    case kRestaurantInfoSectionMax: {
    } break;
  }
  
  return numberOfRows;
}

- (CGFloat)heightForDescriprionCell {
  
  static OMNLabelCell *cell = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    cell = [[OMNLabelCell alloc] init];
  });
  [self configureDescriptionCell:cell];
  
  [cell setNeedsUpdateConstraints];
  [cell updateConstraintsIfNeeded];
  
  cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
  
  [cell setNeedsLayout];
  [cell layoutIfNeeded];
  
  CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 21.0f;
  return height;
  
}

- (void)configureDescriptionCell:(OMNLabelCell *)cell {
  
  cell.separatorInset = UIEdgeInsetsMake(0.0f, CGRectGetWidth(self.view.frame), 0.0f, 0.0f);
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.label.font = FuturaOSFOmnomRegular(18.0f);
  cell.label.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
  cell.label.numberOfLines = 0;
  cell.label.text = _restaurant.Description;
  
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat heightForRow = 44.0f;
  switch ((RestaurantInfoSection)indexPath.section) {
    case kRestaurantInfoSectionName: {
      heightForRow = 50.0f;
    } break;
    case kRestaurantInfoSectionDescription: {
      heightForRow = [self heightForDescriprionCell];
    } break;
    case kRestaurantInfoSectionAbout: {
      heightForRow = 40.0f;
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
      defaultCell.label.text = _restaurant.info.title;
      cell = defaultCell;
      
    } break;
    case kRestaurantInfoSectionDescription: {
      
      OMNLabelCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell" forIndexPath:indexPath];
      [self configureDescriptionCell:descriptionCell];
      cell = descriptionCell;
      
    } break;
    case kRestaurantInfoSectionAbout: {
      
      OMNRestaurantInfoCell *restaurantInfoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
      OMNRestaurantInfoItem *item = _restaurant.info.fullItems[indexPath.row];
      [restaurantInfoCell setItem:item];
      cell = restaurantInfoCell;
      
    } break;
    case kRestaurantInfoSectionFeed: {
      
      OMNRestaurantFeedItemCell *restaurantFeedInfoCell = [tableView dequeueReusableCellWithIdentifier:@"FeedItemCell" forIndexPath:indexPath];
      OMNFeedItem *feedItem = _restaurant.info.feedItems[indexPath.row];
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
      
      OMNRestaurantInfoItem *item = _restaurant.info.fullItems[indexPath.row];
      [item open];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      
    } break;
    case kRestaurantInfoSectionFeed: {
      
      OMNFeedItem *feedItem = _restaurant.info.feedItems[indexPath.row];
      OMNProductDetailsVC *productDetailsVC = [[OMNProductDetailsVC alloc] initFeedItem:feedItem];
      productDetailsVC.delegate = self;
      [self.navigationController pushViewController:productDetailsVC animated:YES];
      
    } break;
    case kRestaurantInfoSectionName:
    case kRestaurantInfoSectionDescription:
    case kRestaurantInfoSectionMax: {
    } break;
  }

}

#pragma mark - OMNProductDetailsVCDelegate

- (void)productDetailsVCDidFinish:(OMNProductDetailsVC *)productDetailsVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - UIScrollViewDelegate

- (UIView *)clearView {
  UIView *clearView = [[UIView alloc] init];
  clearView.backgroundColor = [UIColor clearColor];
  return clearView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *viewForHeader = nil;
  
  switch ((RestaurantInfoSection)section) {
    case kRestaurantInfoSectionFeed: {
      
      if (_restaurant.info.feedItems.count) {
        OMNBottomLabelView *bottomLabelView = [[OMNBottomLabelView alloc] init];
        bottomLabelView.label.text = NSLocalizedString(@"Стоит попробовать", nil);
        viewForHeader = bottomLabelView;
      }
      else {
        viewForHeader = [self clearView];
      }
      
    } break;
    case kRestaurantInfoSectionName: {
      
      viewForHeader = [self clearView];
      
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

- (CGFloat)scrollViewOffset {
  
  const CGFloat startOffset = -40.0f;
  CGFloat offset = startOffset - (self.tableView.contentInset.top + self.tableView.contentOffset.y);
  return offset;
  
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
  
  [self updateNavigationBarLayer];
  
}

- (void)updateNavigationBarLayer {
  
  if (_disableNavigationBarAnimation ||
      _percentDrivenInteractiveTransition) {
    return;
  }
  CALayer *navigationBarLayer = self.navigationController.navigationBar.layer;
  CGFloat deltaOffset = self.tableView.contentOffset.y;

  if (deltaOffset > 0.0f) {
    
    const CGFloat kDistanceToHide = 30.0f;
    _arrowButton.alpha = MAX(0.0f, (kDistanceToHide - deltaOffset)/kDistanceToHide);
    navigationBarLayer.transform = CATransform3DMakeTranslation(0.0f, -deltaOffset - self.tableView.contentInset.top, 0.0f);

  }
  else {
    
    _arrowButton.alpha = 1.0f;
    navigationBarLayer.transform = CATransform3DIdentity;
    
  }
  
}

#pragma mark - OMNInteractiveTransitioningProtocol

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitioning {
  
  return _percentDrivenInteractiveTransition;
  
}

@end
