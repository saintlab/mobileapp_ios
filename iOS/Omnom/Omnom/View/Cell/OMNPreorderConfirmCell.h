//
//  OMNPreorderConfirmCell.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNMenuProduct.h"

@interface OMNPreorderConfirmCell : UITableViewCell

@property (nonatomic, strong) OMNMenuProduct *menuProduct;

@end

@interface OMNPreorderConfirmView : UIView

@property (nonatomic, strong) OMNMenuProduct *menuProduct;

@end