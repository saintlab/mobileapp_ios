//
//  OMNRestaurantAddressSelectionVC.h
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNRestaurant.h"

typedef void(^OMNRestaurantAddressBlock)(OMNRestaurantAddress *restaurantAddress);

@interface OMNRestaurantAddressSelectionVC : UIViewController

@property (nonatomic, copy) OMNRestaurantAddressBlock didSelectRestaurantAddressBlock;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;

@end
