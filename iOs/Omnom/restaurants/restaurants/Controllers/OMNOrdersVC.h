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

@interface OMNOrdersVC : UITableViewController

@property (nonatomic, weak) id<OMNOrdersVCDelegate> delegate;

- (instancetype)initWithOrders:(NSArray *)orders;

@end

@protocol OMNOrdersVCDelegate <NSObject>

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order;

@end
