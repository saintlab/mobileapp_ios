//
//  OMNRestaurantMenuMediator.h
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantActionsVC.h"

@interface OMNRestaurantMediator : NSObject

@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;
@property (nonatomic, assign) BOOL waiterIsCalled;
@property (nonatomic, strong, readonly) OMNTable *table;
@property (nonatomic, strong) OMNOrder *selectedOrder;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant rootViewController:(__weak OMNRestaurantActionsVC *)restaurantActionsVC;

- (void)checkTableAndOrders;
- (void)showUserProfile;

- (void)callBillAction:(__weak UIButton *)button;
- (void)callWaiterAction:(__weak UIButton *)button;

- (void)exitRestaurant;

@end
