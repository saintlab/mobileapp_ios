//
//  OMNMenuProductCellItem.h
//  omnom
//
//  Created by tea on 20.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"
#import "OMNMenuProduct.h"

@protocol OMNMenuProductCellDelegate;
@class OMNMenuProductCell;

typedef NS_ENUM(NSInteger, OMNBottomDelimiterType) {
  kBottomDelimiterTypeNone = 0,
  kBottomDelimiterTypeLine,
};

@interface OMNMenuProductCellItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, strong, readonly) OMNMenuProduct *menuProduct;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, assign) OMNBottomDelimiterType delimiterType;
@property (nonatomic, weak) id<OMNMenuProductCellDelegate> delegate;

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct;

@end

@protocol OMNMenuProductCellDelegate <NSObject>

- (void)menuProductCellDidEdit:(OMNMenuProductCell *)menuProductCell;
- (void)menuProductCellDidSelect:(OMNMenuProductCell *)menuProductCell;

@end
