//
//  GCalculatorVC.h
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculatorVCDelegate.h"
#import "OMNRestaurantMediator.h"

extern const CGFloat kCalculatorTopOffset;

@interface OMNCalculatorVC : UIViewController

@property (nonatomic, weak) id<OMNCalculatorVCDelegate>delegate;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong, readonly) UITableView *splitTableView;
@property (nonatomic, assign, readonly) BOOL productSelectionShown;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end

