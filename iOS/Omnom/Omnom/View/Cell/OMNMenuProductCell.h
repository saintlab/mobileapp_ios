//
//  OMNMenuProductCell.h
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNMenuProductCellItem.h"
#import "OMNMenuProductPriceButton.h"

@protocol OMNMenuProductCellDelegate;

@interface OMNMenuProductCell : UITableViewCell

@property (nonatomic, weak) id<OMNMenuProductCellDelegate> delegate;
@property (nonatomic, strong) OMNMenuProductCellItem *item;
@property (nonatomic, strong, readonly) OMNMenuProductPriceButton *priceButton;
@property (nonatomic, strong, readonly) UIImageView *productIV;
@property (nonatomic, strong, readonly) UILabel *nameLabel;

- (void)priceTap;

@end

@protocol OMNMenuProductCellDelegate <NSObject>

- (void)menuProductCellDidEdit:(OMNMenuProductCell *)menuProductCell;
- (void)menuProductCellDidSelect:(OMNMenuProductCell *)menuProductCell;

@end
