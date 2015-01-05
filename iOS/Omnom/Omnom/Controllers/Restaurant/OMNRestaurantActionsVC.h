//
//  OMNBackgroundVC+restaurant.h
//  omnom
//
//  Created by tea on 30.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNR1VC.h"
#import "OMNRestaurant.h"

@protocol OMNRestaurantActionsVCDelegate;

@interface OMNRestaurantActionsVC : OMNBackgroundVC

@property (nonatomic, strong, readonly) OMNR1VC *r1VC;
@property (nonatomic, weak) id<OMNRestaurantActionsVCDelegate> delegate;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;
- (void)showRestaurantAnimated:(BOOL)animated;

@end

@protocol OMNRestaurantActionsVCDelegate <NSObject>

//- (void)restaurantActionsVC:(OMNRestaurantActionsVC *)restaurantVC didChangeVisitor:(OMNVisitor *)visitor;
- (void)restaurantActionsVCDidFinish:(OMNRestaurantActionsVC *)restaurantVC;

@end
