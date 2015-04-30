//
//  OMNLaunchHandler.h
//  omnom
//
//  Created by tea on 10.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNLaunch.h"

@interface OMNLaunchHandler : NSObject

@property (nonatomic, strong, readonly) OMNLaunch *launch;

+ (instancetype)sharedHandler;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
- (void)applicationWillEnterForeground;
- (void)applicationDidEnterBackground;

- (void)reload;
- (void)reloadWithLaunch:(OMNLaunch *)launch;

- (void)showModalControllerWithURL:(NSURL *)url;

@end
