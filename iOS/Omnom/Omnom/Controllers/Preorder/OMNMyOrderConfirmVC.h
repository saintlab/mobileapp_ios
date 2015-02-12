//
//  OMNPreorderConfirmVC.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNRestaurantMediator.h"

@interface OMNMyOrderConfirmVC : UITableViewController

@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator;

@end
