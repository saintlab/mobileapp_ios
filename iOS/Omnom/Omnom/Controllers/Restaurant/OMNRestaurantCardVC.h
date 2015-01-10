//
//  OMNRestaurantCardVC.h
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNSearchRestaurantMediator.h"

@interface OMNRestaurantCardVC : UIViewController

@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initWithMediator:(OMNSearchRestaurantMediator *)searchRestaurantMediator restaurant:(OMNRestaurant *)restaurant;

@end
