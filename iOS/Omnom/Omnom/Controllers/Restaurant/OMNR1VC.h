//
//  OMNR1VC.h
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"

@class OMNRestaurantMediator;

@interface OMNR1VC : OMNCircleRootVC

@property (nonatomic, assign, readonly) BOOL isViewVisible;
@property (nonatomic, strong, readonly) UITableView *menuTable;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end

