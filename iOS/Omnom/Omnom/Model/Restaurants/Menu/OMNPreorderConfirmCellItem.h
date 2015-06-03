//
//  OMNMenuPreorderedCellItem.h
//  omnom
//
//  Created by tea on 25.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"
#import "OMNMenuProduct.h"

@class OMNPreorderConfirmCell;
@protocol OMNPreorderConfirmCellDelegate;

@interface OMNPreorderConfirmCellItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, strong, readonly) OMNMenuProduct *menuProduct;
@property (nonatomic, weak) id<OMNPreorderConfirmCellDelegate> delegate;
@property (nonatomic, assign) BOOL hidePrice;

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct;

@end

@protocol OMNPreorderConfirmCellDelegate <NSObject>

- (void)preorderConfirmCellDidEdit:(OMNPreorderConfirmCell *)preorderConfirmCell;

@end
