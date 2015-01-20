//
//  GProdductSelectionVC.h
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculatorVCDelegate.h"
#import "OMNRestaurantMediator.h"

@class OMNOrder;

@interface OMNProductSelectionVC : UITableViewController

@property (nonatomic, weak) id<OMNCalculatorVCDelegate>delegate;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end
