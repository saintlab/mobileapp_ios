//
//  OMNRestaurantMenuMediator.h
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchBeaconVC.h"

@class OMNProduct;
@class OMNR1VC;

@interface OMNRestaurantMediator : NSObject

- (instancetype)initWithRootViewController:(OMNR1VC *)restaurantVC;

- (void)showUserProfile;

- (void)showRestaurantInfo;

- (void)callBillAction;

- (void)callWaiterAction;

@end
