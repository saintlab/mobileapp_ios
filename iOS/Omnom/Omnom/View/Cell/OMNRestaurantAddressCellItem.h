//
//  OMNRestaurantAddressCellItem.h
//  omnom
//
//  Created by tea on 01.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"
#import "OMNRestaurantAddress.h"

@interface OMNRestaurantAddressCellItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, strong, readonly) OMNRestaurantAddress *address;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithRestaurantAddress:(OMNRestaurantAddress *)restaurantAddress;

@end
