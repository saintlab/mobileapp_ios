//
//  OMNSearchBeaconVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoadingCircleVC.h"
#import "OMNSearchRestaurantMediator.h"

@protocol OMNSearchRestaurantsVCDelegate;

@interface OMNSearchRestaurantsVC : OMNLoadingCircleVC

@property (nonatomic, weak) id<OMNSearchRestaurantsVCDelegate> delegate;

- (instancetype)initWithMediator:(OMNSearchRestaurantMediator *)searchRestaurantMediator;

@end

@protocol OMNSearchRestaurantsVCDelegate <NSObject>

- (void)searchRestaurantsVCDidCancel:(OMNSearchRestaurantsVC *)searchRestaurantsVC;

@end
