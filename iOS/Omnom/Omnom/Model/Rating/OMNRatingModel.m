//
//  OMNRatingModel.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRatingModel.h"
#import "OMNProduct.h"
#import "OMNRatingProductCell.h"

const NSInteger kRatedProductsCount = 100;

@implementation OMNRatingModel{
  NSMutableArray *_products;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    _products = [[NSMutableArray alloc] initWithCapacity:kRatedProductsCount];
    
    for (int i = 0; i < kRatedProductsCount; i++) {
      OMNProduct *product = [[OMNProduct alloc] init];
      product.imageName = [NSString stringWithFormat:@"product_%d", i%2 + 1];
      [_products addObject:product];
    }
    
    
  }
  return self;
}

- (NSIndexPath *)indexPathForProduct:(OMNProduct *)product {
  
  NSUInteger productIndex = [_products indexOfObject:product];
  if (productIndex == NSNotFound) {
    return nil;
  }
  else {
    return [NSIndexPath indexPathForRow:productIndex inSection:0];
  }
  
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return _products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  [collectionView registerClass:[OMNRatingProductCell class] forCellWithReuseIdentifier:@"prototypeCell"];
  
  OMNRatingProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"prototypeCell"
                                                                       forIndexPath:indexPath];
  OMNProduct *product = _products[indexPath.item];
  cell.product = product;
  
  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  return CGSizeMake(140.0f, 178.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNProduct *product = _products[indexPath.item];
  product.rated = !product.rated;
  
}

@end
