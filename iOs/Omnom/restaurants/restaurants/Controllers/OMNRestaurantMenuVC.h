//
//  GRestaurantMenuVC.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurant.h"
#import "OMNTable.h"

@protocol OMNRestaurantMenuVCDelegate;

@interface OMNRestaurantMenuVC : UIViewController

@property (nonatomic, weak) id<OMNRestaurantMenuVCDelegate> delegate;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant table:(OMNTable *)table;

@end

@protocol OMNRestaurantMenuVCDelegate <NSObject>

- (void)restaurantMenuVCDidFinish:(OMNRestaurantMenuVC *)restaurantMenuVC;

@end