//
//  OMNLunchOrderAlertVC.h
//  omnom
//
//  Created by tea on 25.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"
#import "OMNRestaurant.h"

typedef void(^OMNDidSelectDeliveryBlock)(NSString *date, OMNRestaurantAddress *address);

@interface OMNLunchOrderAlertVC : OMNModalAlertVC

@property (nonatomic, copy) OMNDidSelectDeliveryBlock didSelectDeliveryBlock;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;

@end
