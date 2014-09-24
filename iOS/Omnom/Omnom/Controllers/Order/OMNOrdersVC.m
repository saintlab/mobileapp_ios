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

@interface OMNOrdersVC ()

@end

@implementation OMNOrdersVC {
  NSMutableArray *_orders;
  OMNOrderItemsFlowLayout *_orderItemsFlowLayout;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super initWithNibName:@"OMNOrdersVC" bundle:nil];
  if (self) {
    _visitor = visitor;
    _orders = [visitor.orders mutableCopy];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _orderItemsFlowLayout = [[OMNOrderItemsFlowLayout alloc] init];
  
  UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  backgroundView.contentMode = UIViewContentModeCenter;
  backgroundView.image = [[UIImage imageNamed:@"wood_bg"] omn_blendWithColor:_visitor.restaurant.decoration.background_color];
  self.collectionView.backgroundView = backgroundView;

  [self.collectionView registerClass:[OMNOrderViewCell class] forCellWithReuseIdentifier:@"OMNOrderItemCell"];
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNOrderDidChangeNotification object:_visitor];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidClose:) name:OMNOrderDidCloseNotification object:_visitor];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white_pixel"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = nil;
  
}

- (void)cancelTap {
  
  [self.delegate ordersVCDidCancel:self];
  
}

- (void)orderDidChange:(NSNotification *)n {
  
  [self.collectionView reloadData];
  
}

- (void)orderDidClose:(NSNotification *)n {
  
  OMNOrder *order = n.userInfo[OMNOrderKey];
  if (order) {
    
    NSArray *orders = [_orders copy];
//    [_orders removeObjectAtIndex:[index integerValue]];
//    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[index integerValue] inSection:0]]];
  }
  
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return _orders.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNOrderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OMNOrderItemCell" forIndexPath:indexPath];
  OMNOrder *order = _orders[indexPath.item];
  cell.order = order;
  cell.index = indexPath.item;
  
  return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
////  <UICollectionViewDelegateFlowLayout>
//  return CGSizeMake(273.0f, 415.0f);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

  OMNOrder *order = _orders[indexPath.item];
  _visitor.selectedOrder = order;
  [self.delegate ordersVC:self didSelectOrder:order];
  
}

@end
