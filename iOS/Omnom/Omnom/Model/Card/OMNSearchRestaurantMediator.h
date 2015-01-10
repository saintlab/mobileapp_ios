//
//  OMNSearchRestaurantMediator.h
//  omnom
//
//  Created by tea on 10.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurant.h"
#import "OMNLaunchOptions.h"

@interface OMNSearchRestaurantMediator : NSObject

@property (nonatomic, weak, readonly) UIViewController *rootVC;
@property (nonatomic, strong) OMNLaunchOptions *launchOptions;

@property (nonatomic, copy) dispatch_block_t didFinishBlock;

- (instancetype)initWithRootVC:(__weak UIViewController *)vc;

- (void)searchRestarants;
- (void)showUserProfile;
- (void)scanTableQrTap;
- (void)demoModeTap;
- (void)showRestaurants:(NSArray *)restaurants;
- (void)showRestaurant:(OMNRestaurant *)restaurant;
- (void)showCardForRestaurant:(OMNRestaurant *)restaurant;

@end
