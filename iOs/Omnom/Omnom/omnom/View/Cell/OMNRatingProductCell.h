//
//  OMNRatingProductCell.h
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNProduct.h"

@interface OMNRatingProductCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *iconView;

@property (nonatomic, strong) OMNProduct *product;

@end
