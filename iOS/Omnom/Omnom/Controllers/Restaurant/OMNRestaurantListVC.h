//
//  GRestaurantsVC.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNRestaurant.h"
#import "OMNSearchRestaurantMediator.h"

@interface OMNRestaurantListVC : UITableViewController

@property (nonatomic, strong) NSArray *restaurants;

- (instancetype)initWithMediator:(OMNSearchRestaurantMediator *)searchRestaurantMediator;

@end
