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
#import "OMNViewController.h"
#import "OMNShakeWindow.h"

@interface GAppDelegate ()


@end

@implementation GAppDelegate {
  BOOL _applicationStartedForeground;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [[OMNBeaconBackgroundManager manager] setDidFindBeaconBlock:^(OMNBeacon *beacon, dispatch_block_t comletionBlock) {
    
    [[OMNDecodeBeaconManager manager] handleBackgroundBeacon:beacon completion:comletionBlock];
    
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
  
  [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
  UIFont *font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
  [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
   @{
     NSForegroundColorAttributeName : [UIColor blackColor],
     NSFontAttributeName : font
     } forState:UIControlStateNormal];
  
  [[UINavigationBar appearance] setTitleTextAttributes:
   @{
     NSForegroundColorAttributeName : [UIColor blackColor],
     NSFontAttributeName : font,
     }];
  
  _applicationStartedForeground = YES;
  
  [OMNOperationManager manager];
  [OMNAuthorisation authorisation];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  self.window = [[OMNShakeWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.tintColor = [UIColor blackColor];
  
  OMNStartVC *startVC = [[OMNStartVC alloc] init];
  //  OMNViewController *startVC = [[OMNViewController alloc] init];
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
