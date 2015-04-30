//
//  OMNWishCellItem.h
//  omnom
//
//  Created by tea on 29.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"
#import "OMNOrderItem.h"

@interface OMNWishCellItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, strong, readonly) OMNOrderItem *orderItem;

- (instancetype)initWithOrderItem:(OMNOrderItem *)orderItem;

@end
