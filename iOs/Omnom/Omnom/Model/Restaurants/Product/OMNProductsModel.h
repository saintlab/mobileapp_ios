//
//  OMNProductsModel.h
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNProduct.h"

typedef void(^OMNProductSelectionBlock)(OMNProduct *product);

@interface OMNProductsModel : NSObject
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) OMNProductSelectionBlock productSelectionBlock;

- (NSIndexPath *)indexPathForProduct:(OMNProduct *)product;

@end
