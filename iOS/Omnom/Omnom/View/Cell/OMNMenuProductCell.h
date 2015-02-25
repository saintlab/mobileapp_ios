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
@class OMNMenuProductView;

@interface OMNMenuProductCell : UITableViewCell

@property (nonatomic, weak) id<OMNMenuProductCellDelegate> delegate;
@property (nonatomic, strong) OMNMenuProductCellItem *item;
@property (nonatomic, strong) OMNMenuProductView *menuProductView;

- (void)priceTap;

@end

@interface OMNMenuProductView : UIView {
  
  OMNMenuProductCellItem *_item;
  OMNMenuProductPriceButton *_priceButton;
  UIImageView *_productIV;
  
}

@property (nonatomic, strong) OMNMenuProductCellItem *item;
@property (nonatomic, strong, readonly) OMNMenuProductPriceButton *priceButton;
@property (nonatomic, strong, readonly) UIImageView *productIV;

@end

@protocol OMNMenuProductCellDelegate <NSObject>

- (void)menuProductCellDidEdit:(OMNMenuProductCell *)menuProductCell;
- (void)menuProductCellDidSelect:(OMNMenuProductCell *)menuProductCell;

@end