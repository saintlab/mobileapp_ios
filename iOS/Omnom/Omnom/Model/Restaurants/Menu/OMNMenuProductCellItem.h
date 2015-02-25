//
//  OMNMenuProductCellItem.h
//  omnom
//
//  Created by tea on 20.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuTableCellItemProtocol.h"
#import "OMNMenuProduct.h"

typedef NS_ENUM(NSInteger, OMNBottomDelimiterType) {
  kBottomDelimiterTypeNone = 0,
  kBottomDelimiterTypeLine,
};

@interface OMNMenuProductCellItem : NSObject
<OMNMenuTableCellItemProtocol>

@property (nonatomic, strong, readonly) OMNMenuProduct *menuProduct;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, assign) OMNBottomDelimiterType delimiterType;

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct;

- (BOOL)hasReccomendations;

@end
