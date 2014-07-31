//
//  OMNOrdersVC.h
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderVCDelegate.h"
#import "OMNOrder.h"

@class OMNRestaurant;
@protocol OMNOrdersVCDelegate;

@interface OMNOrdersVC : UICollectionViewController

@property (nonatomic, weak) id<OMNOrdersVCDelegate> delegate;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant orders:(NSArray *)orders;

@end

@protocol OMNOrdersVCDelegate <NSObject>

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order;

- (void)ordersVCDidCancel:(OMNOrdersVC *)ordersVC;

@end
