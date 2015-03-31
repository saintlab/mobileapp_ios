//
//  OMNLunchOrderAlertVC.h
//  omnom
//
//  Created by tea on 25.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"
#import "OMNRestaurant.h"

typedef void(^OMNDidSelectRestaurantBlock)(OMNRestaurant *restaurant);

@interface OMNLunchOrderAlertVC : OMNModalAlertVC

@property (nonatomic, copy) OMNDidSelectRestaurantBlock didSelectRestaurantBlock;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;

@end
