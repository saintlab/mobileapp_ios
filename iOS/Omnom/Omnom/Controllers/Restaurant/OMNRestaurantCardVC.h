//
//  OMNRestaurantCardVC.h
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNRestaurant.h"

@protocol OMNRestaurantCardVCDelegate;

@interface OMNRestaurantCardVC : UIViewController

@property (nonatomic, weak) id<OMNRestaurantCardVCDelegate> delegate;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;

@end

@protocol OMNRestaurantCardVCDelegate <NSObject>

- (void)restaurantCardVC:(OMNRestaurantCardVC *)restaurantCardVC didSelectRestaurant:(OMNRestaurant *)restaurant;
- (void)restaurantCardVCDidFinish:(OMNRestaurantCardVC *)restaurantCardVC;

@end