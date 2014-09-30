//
//  OMNBackgroundVC+restaurant.h
//  omnom
//
//  Created by tea on 30.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNR1VC.h"

@class OMNVisitor;
@protocol OMNRestaurantActionsVCDelegate;

@interface OMNRestaurantActionsVC : OMNBackgroundVC

@property (nonatomic, strong, readonly) OMNVisitor *visitor;
@property (nonatomic, strong, readonly) OMNR1VC *r1VC;
@property (nonatomic, weak) id<OMNRestaurantActionsVCDelegate> delegate;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor;

@end

@protocol OMNRestaurantActionsVCDelegate <NSObject>

- (void)restaurantActionsVC:(OMNRestaurantActionsVC *)restaurantVC didChangeVisitor:(OMNVisitor *)visitor;
- (void)restaurantActionsVCDidFinish:(OMNRestaurantActionsVC *)restaurantVC;

@end
