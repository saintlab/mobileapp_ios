//
//  OMNOrdersVC.h
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderVCDelegate.h"
#import "OMNRestaurantMediator.h"
#import "OMNBackgroundVC.h"

@protocol OMNOrdersVCDelegate;

@interface OMNOrdersVC : OMNBackgroundVC

@property (nonatomic, weak) id<OMNOrdersVCDelegate> delegate;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end

@protocol OMNOrdersVCDelegate <NSObject>

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order;
- (void)ordersVCDidCancel:(OMNOrdersVC *)ordersVC;

@end
