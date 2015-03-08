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

@class OMNPreorderMediator;
@class OMNMyOrderConfirmVC;

@interface OMNRestaurantMediator : NSObject

@property (nonatomic, weak, readonly) OMNRestaurantActionsVC *restaurantActionsVC;
@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;
@property (nonatomic, strong, readonly) OMNVisitor *visitor;
@property (nonatomic, strong) OMNMenu *menu;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant rootViewController:(OMNRestaurantActionsVC *)restaurantActionsVC;

- (long long)totalOrdersAmount;
- (void)checkStartConditions;
- (void)showUserProfile;
- (void)showPreorders;
- (void)waiterCall;
- (void)waiterCallStop;
- (void)requestTableOrders;
- (void)popToRootViewControllerAnimated:(BOOL)animated;
- (void)exitRestaurant;
- (void)rescanTable;

- (UIBarButtonItem *)exitRestaurantButton;
- (UIButton *)userProfileButton;
- (BOOL)showTableButton;
- (BOOL)showPreorderButton;

- (OMNPreorderMediator *)preorderMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC;

@end
