//
//  OMNRestaurantCellItem.h
//  omnom
//
//  Created by tea on 25.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"
#import "OMNRestaurant.h"

@interface OMNRestaurantCellItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;

@end
