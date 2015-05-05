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
#import "OMNAcquiringTransaction.h"

@class OMNWishMediator;
@class OMNMyOrderConfirmVC;

@interface OMNRestaurantMediator : NSObject

@property (nonatomic, weak, readonly) OMNRestaurantActionsVC *restaurantActionsVC;
@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;
@property (nonatomic, strong, readonly) OMNVisitor *visitor;
@property (nonatomic, strong, readonly) OMNTable *table;
@property (nonatomic, strong) OMNMenu *menu;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor rootViewController:(OMNRestaurantActionsVC *)restaurantActionsVC;

- (long long)totalOrdersAmount;
- (void)checkStartConditions;
- (void)showSettings;
- (void)showPreorders;
- (void)showTableOrders;
- (void)showPushPermissionVCWithCompletion:(dispatch_block_t)completionBlock;
- (void)popToRootViewControllerAnimated:(BOOL)animated;
- (void)exitRestaurant;
- (void)rescanTable;
- (void)didFinishPayment;

- (UIBarButtonItem *)exitRestaurantButton;
- (UIButton *)userProfileButton;
- (UIView *)titleView;

- (BOOL)showTableButton;
- (BOOL)showPreorderButton;

- (OMNWishMediator *)wishMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC;

@end
