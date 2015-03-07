//
//  OMNRestaurantMediatorFactory.h
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantMediator.h"

@interface OMNRestaurantMediatorFactory : OMNVisitor

+ (OMNRestaurantMediator *)mediatorWithRestaurant:(OMNRestaurant *)restaurant rootViewController:(OMNRestaurantActionsVC *)restaurantActionsVC;

@end
