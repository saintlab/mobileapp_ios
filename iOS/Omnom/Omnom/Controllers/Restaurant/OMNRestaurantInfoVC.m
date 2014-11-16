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
#import "UIBarButtonItem+omn_custom.h"

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
UIScrollViewDelegate,
UIGestureRecognizerDelegate>

@end

@implementation OMNRestaurantInfoVC {

  OMNVisitor *_visitor;
  BOOL _disableNavigationBarAnimation;
  BOOL _disableSwipeTransition;
  UIPercentDrivenInteractiveTransition *_percentDrivenInteractiveTransition;

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
  
  self.navigationItem.titleView = [UIBarButtonItem omn_buttonWithImage:[UIImage imageNamed:@"back_button_icon"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
  if (NO == _visitor.restaurant.is_demo) {
    
    [[OMNAnalitics analitics] logTargetEvent:@"promolist_view" parametrs:nil];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"user_settings_icon"] color:[UIColor blackColor] target:self action:@selector(userProfileTap)];

  }
  self.automaticallyAdjustsScrollViewInsets = NO;

  self.tableView.tableFooterView = [UIView new];
  [self.tableView registerClass:[OMNRestaurantInfoCell class] forCellReuseIdentifier:@"InfoCell"];
  [self.tableView registerClass:[OMNLabelCell class] forCellReuseIdentifier:@"MoreCell"];
  [self.tableView registerClass:[OMNLabelCell class] forCellReuseIdentifier:@"DefaultCell"];
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
 
  if (_visitor.restaurant.info) {
    return;
  }
  
  [self startAnimating:YES];
  __weak typeof(self)weakSelf = self;
  [_visitor.restaurant advertisement:^(OMNRestaurantInfo *restaurantInfo) {
    
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

- (void)userProfileTap {
  [self.delegate restaurantInfoVCShowUserInfo:self];
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
  NSUInteger index = [_visitor.restaurant.info.feedItems indexOfObject:feedItem];
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
      numberOfRows = (_visitor.restaurant.info.selected) ? (_visitor.restaurant.info.fullItems.count) : (_visitor.restaurant.info.shortItems.count);
    } break;
    case kRestaurantInfoSectionMore: {
      numberOfRows = (nil == _visitor.restaurant.info || _visitor.restaurant.info.selected) ? (0) : (1);
    } break;
    case kRestaurantInfoSectionFeed: {
      numberOfRows = _visitor.restaurant.info.feedItems.count;
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
      defaultCell.label.text = _visitor.restaurant.info.title;
      cell = defaultCell;
      
    } break;
    case kRestaurantInfoSectionAbout: {
      
      OMNRestaurantInfoCell *restaurantInfoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
      NSArray *items = (_visitor.restaurant.info.selected) ? (_visitor.restaurant.info.fullItems) : (_visitor.restaurant.info.shortItems);
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
      OMNFeedItem *feedItem = _visitor.restaurant.info.feedItems[indexPath.row];
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
      
      NSArray *items = (_visitor.restaurant.info.selected) ? (_visitor.restaurant.info.fullItems) : (_visitor.restaurant.info.shortItems);
      OMNRestaurantInfoItem *item = items[indexPath.row];
      [item open];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      
    } break;
    case kRestaurantInfoSectionMore: {

      if (_visitor.restaurant.info) {
        _visitor.restaurant.info.selected = !_visitor.restaurant.info.selected;
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kRestaurantInfoSectionMore]] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:kRestaurantInfoSectionAbout] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
      }
      
    } break;
    case kRestaurantInfoSectionFeed: {
      
      OMNFeedItem *feedItem = _visitor.restaurant.info.feedItems[indexPath.row];
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

- (UIView *)clearView {
  UIView *clearView = [[UIView alloc] init];
  clearView.backgroundColor = [UIColor clearColor];
  return clearView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *viewForHeader = nil;
  
  switch ((RestaurantInfoSection)section) {
    case kRestaurantInfoSectionFeed: {
      
      if (_visitor.restaurant.info.feedItems.count) {
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

    navigationBarLayer.transform = CATransform3DMakeTranslation(0.0f, -deltaOffset - self.tableView.contentInset.top, 0.0f);

  }
  else {
    
    navigationBarLayer.transform = CATransform3DIdentity;
    
  }
  
}

#pragma mark - OMNInteractiveTransitioningProtocol

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitioning {
  return _percentDrivenInteractiveTransition;
}

@end
