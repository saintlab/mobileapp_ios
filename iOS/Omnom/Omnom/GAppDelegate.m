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

@implementation GAppDelegate {
  BOOL _applicationStartedForeground;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
#if OMN_TEST
  return YES;
#endif
  
  if ([OMNConstants useBackgroundNotifications]) {
    [[OMNBeaconBackgroundManager manager] setDidFindBeaconBlock:^(OMNBeacon *beacon, dispatch_block_t comletionBlock) {
      
      [OMNAuthorisation authorisation];
      [[OMNVisitorManager manager] handleBackgroundBeacon:beacon completion:comletionBlock];
      
    }];
  }
  
  if (nil == launchOptions[UIApplicationLaunchOptionsLocationKey]) {
    [self startApplication:nil];
  }
  
  return YES;
  
}

- (void)startApplication:(NSDictionary *)info {

  if (_applicationStartedForeground) {
    return;
  }

#if defined (APP_STORE)
  [OMNConstants setCustomConfigName:@"config_prod"];
#elif defined (AD_HOC)
  [OMNConstants setCustomConfigName:@"config_prod"];
#else
  [OMNConstants setCustomConfigName:@"config_prod"];
#endif
  [OMNMailRuAcquiring setConfig:[OMNConstants mailRuConfig]];
  
  [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
  UIFont *font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
  [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
   @{
     NSForegroundColorAttributeName : [UIColor blackColor],
     NSFontAttributeName : font
     } forState:UIControlStateNormal];
  [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
   @{
     NSForegroundColorAttributeName : [UIColor lightGrayColor],
     NSFontAttributeName : font
     } forState:UIControlStateDisabled];
  
  [[UINavigationBar appearance] setTitleTextAttributes:
   @{
     NSForegroundColorAttributeName : [UIColor blackColor],
     NSFontAttributeName : font,
     }];
  
  _applicationStartedForeground = YES;
  
  [OMNOperationManager sharedManager];
  [OMNAuthorisation authorisation];
  
  [Crashlytics startWithAPIKey:[OMNConstants crashlyticsAPIKey]];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.tintColor = [UIColor blackColor];
  
//  OMNRatingVC *startVC = [[OMNRatingVC alloc] init];
  OMNStartVC *startVC = [[OMNStartVC alloc] init];
  startVC.info = info;
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
