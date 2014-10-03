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
#import "OMNVisitorManager.h"
#import "OMNOperationManager.h"
#import "OMNViewController.h"
#import <Crashlytics/Crashlytics.h>
#import <OMNMailRuAcquiring.h>
#import "NSURL+omn_query.h"

@implementation GAppDelegate {
  BOOL _applicationStartedForeground;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
#if OMN_TEST
  return YES;
#endif
  
#if defined (APP_STORE)
  [OMNConstants setCustomConfigName:@"config_prod"];
#else
  
  NSDictionary *parametrs = [launchOptions[UIApplicationLaunchOptionsURLKey] omn_query];
  if (parametrs[@"omnom_config"]) {
    [OMNConstants setCustomConfigName:parametrs[@"omnom_config"]];
  }
  else {
    [OMNConstants setCustomConfigName:@"config_prod"];
  }
#endif
  
  NSLog(@"%@", launchOptions);
  [OMNAuthorisation authorisation];
  
  if ([OMNConstants useBackgroundNotifications]) {
    [[OMNBeaconBackgroundManager manager] setDidFindBeaconBlock:^(OMNBeacon *beacon, dispatch_block_t comletionBlock) {
      
      [[OMNVisitorManager manager] handleBackgroundBeacon:beacon completion:comletionBlock];
      
    }];
  }
  
  if (nil == launchOptions[UIApplicationLaunchOptionsLocationKey]) {
    [self startApplication:launchOptions];
  }
  
  return YES;
  
}

- (void)startApplication:(NSDictionary *)info {

  if (_applicationStartedForeground) {
    return;
  }
  _applicationStartedForeground = YES;

  [OMNConstants loadConfigWithCompletion:nil];
  
  [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
  UIFont *buttonFont = FuturaOSFOmnomRegular(20.0f);
  [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
   @{
     NSForegroundColorAttributeName : [UIColor blackColor],
     NSFontAttributeName : buttonFont
     } forState:UIControlStateNormal];
  [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
   @{
     NSForegroundColorAttributeName : [UIColor lightGrayColor],
     NSFontAttributeName : buttonFont
     } forState:UIControlStateDisabled];
  
  UIFont *titleFont = FuturaOSFOmnomMedium(20.0f);
  [[UINavigationBar appearance] setTitleTextAttributes:
   @{
     NSForegroundColorAttributeName : [UIColor blackColor],
     NSFontAttributeName : titleFont,
     }];
  
  
  [OMNOperationManager sharedManager];
  
  [Crashlytics startWithAPIKey:[OMNConstants crashlyticsAPIKey]];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.tintColor = [UIColor blackColor];
  
  OMNStartVC *startVC = [[OMNStartVC alloc] init];
  startVC.info = info;
  
//  OMNViewController*startVC = [[OMNViewController alloc] init];
  
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
  NSLog(@"url recieved: %@", [url query]);
  NSLog(@"sourceApplication: %@", sourceApplication);
  NSLog(@"annotation: %@", annotation);
  return YES;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
  NSLog(@"handleActionWithIdentifier>%@ forLocalNotification>%@", identifier, notification);
  completionHandler();

}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
  NSLog(@"handleActionWithIdentifier>%@ forRemoteNotification>%@", identifier, userInfo);
  completionHandler();
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  
  NSLog(@"didReceiveLocalNotification>%@", notification);
  if (notification.userInfo[OMNDecodeBeaconManagerNotificationLaunchKey]) {
    [self startApplication:notification.userInfo];
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
  [self startApplication:nil];
  
}

@end
