//
//  OMNLaunchOptions.h
//  omnom
//
//  Created by tea on 08.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurant.h"

@interface OMNLaunchOptions : NSObject

@property (nonatomic, copy, readonly) NSString *customConfigName;
@property (nonatomic, copy, readonly) NSString *qr;
@property (nonatomic, copy, readonly) NSString *hashString;
@property (nonatomic, assign) BOOL showTableOrders;
@property (nonatomic, strong, readonly) NSArray *restaurants;
@property (nonatomic, assign, readonly) BOOL applicationWasOpenedByBeacon;

- (instancetype)initWithLaunchOptions:(NSDictionary *)launchOptions;
- (instancetype)initWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (instancetype)initWithLocanNotification:(UILocalNotification *)localNotification;
- (instancetype)initWithRemoteNotification:(NSDictionary *)info;

@end
