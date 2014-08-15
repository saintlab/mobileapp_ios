//
//  OMNRestaurantInfoVC.h
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNRestaurant.h"

@protocol OMNRestaurantInfoVCDelegate;

@interface OMNRestaurantInfoVC : UITableViewController

@property (nonatomic, weak) id<OMNRestaurantInfoVCDelegate> delegate;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;

@end

@protocol OMNRestaurantInfoVCDelegate <NSObject>

- (void)restaurantInfoVCDidFinish:(OMNRestaurantInfoVC *)restaurantInfoVC;

@end