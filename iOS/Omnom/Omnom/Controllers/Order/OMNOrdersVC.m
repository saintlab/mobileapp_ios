//
//  OMNOrdersVC.m
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrdersVC.h"
#import "OMNOrderItemCell.h"
#import "OMNVisitor.h"
#import "OMNOrderItemsFlowLayout.h"

@interface OMNOrdersVC ()

@end

@implementation OMNOrdersVC {
  NSArray *_orders;
  OMNOrderItemsFlowLayout *_orderItemsFlowLayout;
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super initWithNibName:@"OMNOrdersVC" bundle:nil];
  if (self) {
    _visitor = visitor;
    _orders = visitor.orders;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _orderItemsFlowLayout = [[OMNOrderItemsFlowLayout alloc] init];
  
  self.collectionView.backgroundColor = _visitor.restaurant.background_color;
  [self.collectionView registerClass:[OMNOrderItemCell class] forCellWithReuseIdentifier:@"OMNOrderItemCell"];
  
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
  
  OMNOrderItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OMNOrderItemCell" forIndexPath:indexPath];
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
