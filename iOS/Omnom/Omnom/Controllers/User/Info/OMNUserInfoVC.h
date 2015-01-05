//
//  OMNUserInfoVC.h
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantMediator.h"

@protocol OMNUserInfoVCDelegate;

@interface OMNUserInfoVC : UITableViewController

@property (nonatomic, weak) id<OMNUserInfoVCDelegate> delegate;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end

@protocol OMNUserInfoVCDelegate <NSObject>

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC;

@end