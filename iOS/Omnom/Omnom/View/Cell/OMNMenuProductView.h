//
//  OMNMenuProductView.h
//  omnom
//
//  Created by tea on 26.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNMenuProductSelectionItem.h"

@interface OMNMenuProductView : UIView

@property (nonatomic, strong) OMNMenuProductSelectionItem *menuProductSelectionItem;
@property (nonatomic, strong, readonly) UIButton *priceButton;
@property (nonatomic, strong, readonly) UIImageView *productIV;

@end