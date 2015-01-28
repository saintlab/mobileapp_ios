//
//  OMNMyOrderButton.h
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNRestaurantMediator.h"

@interface OMNMyOrderButton : UIButton

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator;

@end
