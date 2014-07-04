//
//  OMNRestaurantMenuMediator.h
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNProduct;

@interface OMNRestaurantMenuMediator : NSObject

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

- (void)showUserProfile;

- (void)processOrders:(NSArray *)orders;

- (void)showProductDetails:(OMNProduct *)product;

@end
