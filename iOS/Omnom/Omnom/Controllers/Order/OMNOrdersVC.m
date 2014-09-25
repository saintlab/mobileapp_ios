//
//  OMNOrdersVC.m
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrdersVC.h"
#import "OMNOrderViewCell.h"
#import "OMNVisitor.h"
#import "OMNOrderItemsFlowLayout.h"
#import "UIImage+omn_helper.h"
#import "OMNToolbarButton.h"

@interface OMNOrdersVC ()
<UICollectionViewDataSource,
UICollectionViewDelegate>

@end

@implementation OMNOrdersVC {
  NSMutableArray *_orders;
  BOOL _animationPerformed;
  UILabel *_label;
  UIPageControl *_pageControl;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super init];
  if (self) {
    _visitor = visitor;
    _orders = [visitor.orders mutableCopy];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setup];
  
  self.automaticallyAdjustsScrollViewInsets = YES;
  
  _label.font = FuturaOSFOmnomRegular(15);
  _label.textAlignment = NSTextAlignmentCenter;
  _label.textColor = [UIColor colorWithWhite:146.0f/255.0f alpha:1.0f];
  [self updateOrders];
  
  _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
  _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
  
  UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  backgroundView.contentMode = UIViewContentModeCenter;
  backgroundView.image = [[UIImage imageNamed:@"wood_bg"] omn_blendWithColor:_visitor.restaurant.decoration.background_color];
  _collectionView.backgroundView = backgroundView;

  OMNToolbarButton *cancelButton = [[OMNToolbarButton alloc] initWithImage:nil title:NSLocalizedString(@"Отмена", nil)];
  [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [cancelButton addTarget:self action:@selector(cancelTap) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNOrderDidChangeNotification object:_visitor];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidClose:) name:OMNOrderDidCloseNotification object:_visitor];
  
}

- (void)updateOrders {
  
  _label.text = [NSString stringWithFormat:NSLocalizedString(@"На вашем столике\n%d раздельных счетов", nil), _orders.count];
  _pageControl.numberOfPages = _orders.count;

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
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-(-11)-[label]-7-|" options:0 metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:views]];
  
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
  
  [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
    _label.alpha = 1.0f;
    _pageControl.alpha = 1.0f;
  } completion:nil];
}

- (void)cancelTap {
  
  [self.delegate ordersVCDidCancel:self];
  
}

- (void)orderDidChange:(NSNotification *)n {
  
  [_collectionView reloadData];
  
}

- (void)orderDidClose:(NSNotification *)n {
  
  OMNOrder *closeOrder = n.userInfo[OMNOrderKey];
  if (nil == closeOrder) {
    return;
  }
  
  NSArray *orders = [_orders copy];
  [orders enumerateObjectsUsingBlock:^(OMNOrder *order, NSUInteger idx, BOOL *stop) {
    
    if ([order.id isEqualToString:closeOrder.id]) {
      [_orders removeObjectAtIndex:idx];
      [_collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]]];
      *stop = YES;
    }
    
  }];
  
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return _orders.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNOrderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  OMNOrder *order = _orders[indexPath.item];
  
  if (1 == indexPath.item &&
      NO == _animationPerformed) {
    _animationPerformed = YES;
    
    CGAffineTransform initialTransform = cell.transform;
    cell.transform = CGAffineTransformConcat(initialTransform, CGAffineTransformMakeTranslation(0.0f, -500.0f));
    [UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
      cell.transform = initialTransform;
    } completion:nil];

  }
  
  cell.order = order;
  cell.index = indexPath.item;

  return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

  OMNOrder *order = _orders[indexPath.item];
  _visitor.selectedOrder = order;
  [self.delegate ordersVC:self didSelectOrder:order];
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  __block NSInteger index = -1;
  __block CGFloat minSpacing = 999.0f;
  CGFloat centerX = scrollView.contentOffset.x + CGRectGetMidX(scrollView.frame);
  [_collectionView.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
    
    CGFloat spacing = fabsf(cell.center.x - centerX);
    if (spacing < minSpacing) {
      minSpacing = spacing;
      index = [_collectionView indexPathForCell:cell].item;
    }
    
  }];
  
  _pageControl.currentPage = index;
  
}


@end
