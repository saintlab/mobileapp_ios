//
//  OMNUserInfoVC.h
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantMediator.h"

@interface OMNUserInfoVC : UITableViewController

@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end
