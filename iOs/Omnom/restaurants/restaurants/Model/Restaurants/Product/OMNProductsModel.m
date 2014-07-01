//
//  OMNProductsModel.m
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNProductsModel.h"
#import "OMNStubProductCell.h"

const NSInteger kProductsCount = 100;

@implementation OMNProductsModel {
  NSMutableArray *_products;
}

- (instancetype)init
{
  self = [super init];
  if (self) {

    _products = [[NSMutableArray alloc] initWithCapacity:kProductsCount];
    
    for (int i = 0; i < kProductsCount; i++) {
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
  
  [collectionView registerClass:[OMNStubProductCell class] forCellWithReuseIdentifier:@"prototypeCell"];
  
  OMNStubProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"prototypeCell"
                                                                          forIndexPath:indexPath];
  OMNProduct *product = _products[indexPath.item];
  cell.iconView.image = [UIImage imageNamed:product.imageName];

  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  return CGSizeMake(140.0f, 178.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
  if (self.productSelectionBlock) {
    OMNProduct *product = _products[indexPath.item];
    self.productSelectionBlock(product);
  }
  
}

@end
