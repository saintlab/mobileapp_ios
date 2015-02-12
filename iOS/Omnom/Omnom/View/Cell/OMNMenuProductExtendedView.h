//
//  OMNMenuProductDetailsView.h
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuProduct.h"

@interface OMNMenuProductExtendedView : UIView

@property (nonatomic, strong) OMNMenuProduct *menuProduct;
@property (nonatomic, strong, readonly) UIButton *priceButton;
@property (nonatomic, strong, readonly) UIImageView *productIV;

@end
