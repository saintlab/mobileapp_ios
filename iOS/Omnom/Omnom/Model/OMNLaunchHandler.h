//
//  OMNLaunchHandler.h
//  omnom
//
//  Created by tea on 10.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNLaunchOptions.h"

@interface OMNLaunchHandler : NSObject

@property (nonatomic, strong) OMNLaunchOptions *launchOptions;

+ (instancetype)sharedHandler;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
- (void)didFinishLaunchingWithOptions:(OMNLaunchOptions *)lo;
- (void)applicationWillEnterForeground;

@end
