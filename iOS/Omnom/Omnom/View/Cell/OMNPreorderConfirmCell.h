//
//  OMNPreorderConfirmCell.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNMenuProduct.h"

@protocol OMNPreorderConfirmCellDelegate;

@interface OMNPreorderConfirmCell : UITableViewCell

@property (nonatomic, strong) OMNMenuProduct *menuProduct;
@property (nonatomic, weak) id<OMNPreorderConfirmCellDelegate> delegate;

@end

@interface OMNPreorderConfirmView : UIView

@property (nonatomic, strong) OMNMenuProduct *menuProduct;
@property (nonatomic, strong, readonly) UIButton *priceButton;

@end

@protocol OMNPreorderConfirmCellDelegate <NSObject>

- (void)preorderConfirmCell:(OMNPreorderConfirmCell *)preorderConfirmCell didEditMenuProduct:(OMNMenuProduct *)menuProduct;

@end