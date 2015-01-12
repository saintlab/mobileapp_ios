//
//  OMNRestaurantMenuMediator.h
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantActionsVC.h"

@interface OMNRestaurantMediator : NSObject

@property (nonatomic, weak, readonly) OMNRestaurantActionsVC *restaurantActionsVC;
@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;
@property (nonatomic, assign) BOOL waiterIsCalled;
@property (nonatomic, strong) OMNTable *table;
@property (nonatomic, strong) OMNOrder *selectedOrder;
@property (nonatomic, strong) NSArray *orders;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant rootViewController:(__weak OMNRestaurantActionsVC *)restaurantActionsVC;

- (void)checkOrders;
- (void)showUserProfile;

- (void)waiterCallWithCompletion:(dispatch_block_t)completionBlock;
- (void)waiterCallStopWithCompletion:(dispatch_block_t)completionBlock;
- (void)callBill;

- (void)popToRootViewControllerAnimated:(BOOL)animated;

- (void)exitRestaurant;

@end
