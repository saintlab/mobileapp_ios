//
//  GRestaurantMenuVC.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurant.h"
#import "OMNTable.h"

@interface GRestaurantMenuVC : UIViewController

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant table:(OMNTable *)table;

@end
