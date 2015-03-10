//
//  GPaymentVC.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNOrderTableView.h"
#import "OMNRestaurantMediator.h"

@protocol OMNOrderCalculationVCDelegate;

@interface OMNOrderCalculationVC : OMNBackgroundVC

@property (nonatomic, strong) OMNOrderTableView *tableView;
@property (nonatomic, weak) id<OMNOrderCalculationVCDelegate> delegate;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end

@protocol OMNOrderCalculationVCDelegate <NSObject>

- (void)orderCalculationVCRequestOrders:(OMNOrderCalculationVC *)orderCalculationVC;
- (void)orderCalculationVCDidCancel:(OMNOrderCalculationVC *)orderCalculationVC;

@end