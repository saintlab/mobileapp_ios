//
//  OMNMenuProductView.h
//  omnom
//
//  Created by tea on 26.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNMenuProduct.h"
#import "OMNMenuProductPriceButton.h"

@interface OMNMenuProductView : UIView

@property (nonatomic, strong) OMNMenuProduct *menuProduct;
@property (nonatomic, strong, readonly) OMNMenuProductPriceButton *priceButton;
@property (nonatomic, strong, readonly) UIImageView *productIV;

@end
