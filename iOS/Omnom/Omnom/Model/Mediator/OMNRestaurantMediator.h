//
//  OMNRestaurantMenuMediator.h
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchVisitorVC.h"

@class OMNProduct;
@class OMNRestaurantActionsVC;

@interface OMNRestaurantMediator : NSObject

@property (nonatomic, strong, readonly) OMNVisitor *visitor;

- (instancetype)initWithRootViewController:(OMNRestaurantActionsVC *)restaurantActionsVC;

- (void)showUserProfile;

- (void)callBillAction:(UIButton *)button;
- (void)callWaiterAction:(UIButton *)button;

- (void)exitRestaurant;

@end
