//
//  OMNOrdersVC.m
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrdersVC.h"
#import "OMNOrderViewCell.h"
#import "OMNOrderItemsFlowLayout.h"
#import "UIImage+omn_helper.h"
#import "OMNToolbarButton.h"
#import "OMNRestaurantManager.h"
#import <OMNStyler.h>

@interface OMNOrdersVC ()
<UICollectionViewDataSource,
UICollectionViewDelegate>

@end

@implementation OMNOrdersVC {
  
  BOOL _animationPerformed;
  UILabel *_label;
  UIPageControl *_pageControl;
  OMNRestaurantMediator *_restaurantMediator;
  OMNTable *_table;
  
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    _table = restaurantMediator.table;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setup];
  
  self.automaticallyAdjustsScrollViewInsets = YES;
  self.view.backgroundColor = [UIColor clearColor];
  _label.font = FuturaLSFOmnomLERegular(15.0f);
  _label.textAlignment = NSTextAlignmentCenter;
  _label.textColor = [UIColor colorWithWhite:146.0f/255.0f alpha:1.0f];
  [self updateOrders];
  
  _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
  _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
  
  _collectionView.backgroundColor = [UIColor clearColor];
  self.backgroundImage = _restaurantMediator.restaurant.decoration.woodBackgroundImage;
  
  OMNToolbarButton *cancelButton = [[OMNToolbarButton alloc] initWithImage:nil title:kOMN_CLOSE_BUTTON_TITLE];
  [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [cancelButton addTarget:self action:@selector(cancelTap) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:OMNTableOrdersDidChangeNotification object:nil];
  
}

- (void)setup {
  
  _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[OMNOrderItemsFlowLayout alloc] init]];
  [_collectionView registerClass:[OMNOrderViewCell class] forCellWithReuseIdentifier:@"Cell"];
  _collectionView.delegate = self;
  _collectionView.dataSource = self;
  _collectionView.showsHorizontalScrollIndicator = NO;
  _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_collectionView];
  
  _label = [[UILabel alloc] init];
  _label.numberOfLines = 0;
  _label.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_label];
  
  _pageControl = [[UIPageControl alloc] init];
  _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_pageControl];
  
  NSDictionary *views =
  @{
    @"label" : _label,
    @"pageControl" : _pageControl,
    @"collectionView" : _collectionView,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-(-11)-[label]-7-|" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:kNilOptions metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:kNilOptions metrics:nil views:views]];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  
  _label.alpha = 0.0f;
  _pageControl.alpha = 0.0f;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [UIView animateWithDuration:0.3 delay:0.3 options:kNilOptions animations:^{
    _label.alpha = 1.0f;
    _pageControl.alpha = 1.0f;
  } completion:nil];
}

- (void)cancelTap {
  
  [self.delegate ordersVCDidCancel:self];
  
}

- (void)reloadData {
  
  [_collectionView reloadData];
  [self updateOrders];
  
}

- (NSString *)stringFromOrdersCount:(NSInteger)ordersCount {
  
  NSInteger decimal = ordersCount/10;
  NSInteger left = ordersCount%10;
  
  NSString *string = @"";
  if (0 == ordersCount) {
    
    string = kOMN_NO_ORDERS_ON_TABLE_TEXT;
    
  }
  //  для кол-ва счетов: 6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25, 26, 27, 28, 29, 30, 35, 36 и т.д.
  else if (1 == decimal ||
           0 == left ||
           left >= 5) {
    
    string = [NSString stringWithFormat:kOMN_ORDERS_ON_TABLE_TEXT3, ordersCount];
    
  }
  //  для кол-ва счетов: 1, 21, 31, и т.д.
  else if (1 == left) {
    
    string = [NSString stringWithFormat:kOMN_ORDERS_ON_TABLE_TEXT2, ordersCount];
    
  }
  //  для кол-ва счетов: 2,3,4,22,23,24,32,33,34 и т.д.
  else if (left < 5) {
    
    string = [NSString stringWithFormat:kOMN_ORDERS_ON_TABLE_TEXT1, ordersCount];
    
  }
  
  return string;
  
}

//https://github.com/saintlab/mobileapp_ios/issues/375#issuecomment-78023185
- (void)updateOrders {
  
  NSInteger ordersCount = _table.orders.count;
  _label.text = [self stringFromOrdersCount:ordersCount];
  _pageControl.numberOfPages = ordersCount;
  @weakify(self)
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    @strongify(self)
    [self updateSelectedIndex];
    
  });
  
}

- (void)updateSelectedIndex {
  
  __block NSInteger index = -1;
  __block CGFloat minSpacing = 999.0f;
  CGFloat centerX = _collectionView.contentOffset.x + CGRectGetMidX(_collectionView.frame);
  [_collectionView.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
    
    CGFloat spacing = fabs(cell.center.x - centerX);
    if (spacing < minSpacing) {
      minSpacing = spacing;
      index = [_collectionView indexPathForCell:cell].item;
    }
    
  }];
  
  _pageControl.currentPage = index;
  
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  
  return 1;
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  return _table.orders.count;
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNOrderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  OMNOrder *order = _table.orders[indexPath.item];
  
  if (1 == indexPath.item &&
      !_animationPerformed) {
    _animationPerformed = YES;
    
    CGAffineTransform initialTransform = cell.transform;
    cell.transform = CGAffineTransformConcat(initialTransform, CGAffineTransformMakeTranslation(0.0f, -500.0f));
    [UIView animateWithDuration:0.5 delay:1 options:kNilOptions animations:^{
      cell.transform = initialTransform;
    } completion:nil];

  }
  
  cell.order = order;
  cell.index = indexPath.item;

  return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

  OMNOrder *order = _table.orders[indexPath.item];
  [self.delegate ordersVC:self didSelectOrder:order];
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  [self updateSelectedIndex];
  
}

@end
