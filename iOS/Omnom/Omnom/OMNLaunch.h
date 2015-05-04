//
//  OMNLaunchOptions.h
//  omnom
//
//  Created by tea on 08.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurant.h"
#import <PromiseKit.h>

@interface OMNLaunch : NSObject

@property (nonatomic, assign) BOOL showTableOrders;
@property (nonatomic, assign) BOOL showRecommendations;
@property (nonatomic, copy) NSString *wishID;
@property (nonatomic, strong) NSURL *openURL;

- (NSString *)customConfigName;
- (BOOL)applicationStartedBackground;
- (BOOL)shouldReload;
- (PMKPromise *)getRestaurants;

@end
