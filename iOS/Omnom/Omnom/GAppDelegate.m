//
//  GAppDelegate.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GAppDelegate.h"
#import "OMNAuthorisation.h"
#import "OMNStartVC.h"
#import "OMNBeaconBackgroundManager.h"
#import "OMNDecodeBeaconManager.h"
#import "OMNOperationManager.h"

@interface GAppDelegate ()


@end

@implementation GAppDelegate {
  UIImageView *_splashIV;
  BOOL _applicationStartedForeground;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [[OMNBeaconBackgroundManager manager] setDidFindBeaconBlock:^(OMNBeacon *beacon, dispatch_block_t comlitionBlock) {
    
    [[OMNDecodeBeaconManager manager] handleBackgroundBeacon:beacon complition:comlitionBlock];
    
  }];
  
  if (nil == launchOptions[UIApplicationLaunchOptionsLocationKey]) {
    [self startApplication];
  }
  
  return YES;
  
}

- (void)startApplication {

  if (_applicationStartedForeground) {
    return;
  }
  
  _applicationStartedForeground = YES;
  
  [OMNOperationManager manager];
  [OMNAuthorisation authorisation];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  OMNStartVC *startVC = [[OMNStartVC alloc] init];
  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:startVC];
  
  [self.window makeKeyAndVisible];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken>%@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  NSLog(@"url recieved: %@", url);
  NSLog(@"sourceApplication: %@", sourceApplication);
  NSLog(@"annotation: %@", annotation);
  return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  
  NSLog(@"didReceiveLocalNotification>%@", notification);
  if (notification.userInfo[OMNDecodeBeaconManagerNotificationLaunchKey]) {
    [self startApplication];
  }
  
  
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
  NSLog(@"%@", notificationSettings.categories);
  NSLog(@"%@", notificationSettings);
}
#endif

- (void)applicationWillEnterForeground:(UIApplication *)application {
  
  NSLog(@"applicationWillEnterForeground");
  [self startApplication];
  
}

@end
