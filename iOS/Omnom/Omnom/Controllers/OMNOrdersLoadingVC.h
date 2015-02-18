//
//  OMNSearchOrdersVC.h
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLoadingCircleVC.h"
#import "OMNRestaurantMediator.h"

@interface OMNOrdersLoadingVC : OMNLoadingCircleVC

@property (nonatomic, copy) OMNOrdersBlock didLoadOrdersBlock;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end
