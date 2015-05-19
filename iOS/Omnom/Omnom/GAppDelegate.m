//
//  GAppDelegate.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GAppDelegate.h"
#import "OMNAnalitics.h"
#import "OMNAuthorization.h"
#import "OMNBeaconBackgroundManager.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"
#import "OMNBackgroundVC.h"
#import <BlocksKit.h>
#import "OMNLaunchHandler.h"
#import "OMNRestaurantManager.h"
#import "OMNNearestBeaconSearchManager.h"
#import "OMNLaunchFactory.h"
#import "OMNConstants.h"
#import <OMNMailRuAcquiring.h>

@implementation GAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#if OMN_TEST
#else

  OMNLaunch *launch = [OMNLaunchFactory launchWithLaunchOptions:launchOptions];
  [[OMNLaunchHandler sharedHandler] reloadWithLaunch:launch];
  
#endif

  return YES;
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  [[OMNAuthorization authorization] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
  [OMNAnalitics analitics].deviceToken = deviceToken;
  
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [[OMNAuthorization authorization] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {

  [[OMNAuthorization authorization] application:application didRegisterUserNotificationSettings:notificationSettings];
  [OMNAnalitics analitics].notificationSettings = notificationSettings;
  
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

  [[OMNLaunchHandler sharedHandler] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
  return YES;
  
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
  DDLogDebug(@"handleActionWithIdentifier>%@ forLocalNotification>%@", identifier, notification);
  completionHandler();

}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
  DDLogDebug(@"handleActionWithIdentifier>%@ forRemoteNotification>%@", identifier, userInfo);
  completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  [[OMNAnalitics analitics] logDebugEvent:@"didReceiveRemoteNotification" parametrs:userInfo];
  [[OMNLaunchHandler sharedHandler] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  [[OMNLaunchHandler sharedHandler] didReceiveLocalNotification:notification];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[OMNLaunchHandler sharedHandler] applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [[OMNLaunchHandler sharedHandler] applicationWillEnterForeground];
}

@end
