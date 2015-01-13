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
@interface OMNRestaurantActionsVC : OMNBackgroundVC

@property (nonatomic, strong, readonly) OMNR1VC *r1VC;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;
@property (nonatomic, copy) dispatch_block_t rescanTableBlock;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;
- (void)showRestaurantAnimated:(BOOL)animated;

@end
