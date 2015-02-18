//
//  OMNRestaurantMenuMediator.h
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantActionsVC.h"
#import "OMNMenu.h"
#import "OMNVisitor.h"

@interface OMNRestaurantMediator : NSObject

@property (nonatomic, weak, readonly) OMNRestaurantActionsVC *restaurantActionsVC;
@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;
@property (nonatomic, assign) BOOL waiterIsCalled;
@property (nonatomic, strong, readonly) OMNVisitor *visitor;
@property (nonatomic, strong) OMNMenu *menu;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant rootViewController:(__weak OMNRestaurantActionsVC *)restaurantActionsVC;

- (long long)totalOrdersAmount;
- (void)checkOrders;
- (void)showUserProfile;
- (void)myOrderTap;
- (void)waiterCallWithCompletion:(dispatch_block_t)completionBlock;
- (void)waiterCallStopWithCompletion:(dispatch_block_t)completionBlock;
- (void)requestTableOrders;
- (void)popToRootViewControllerAnimated:(BOOL)animated;

- (void)exitRestaurant;
- (void)rescanTable;

@end
