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

@implementation GAppDelegate {
  
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#if OMN_TEST
  return YES;
#endif
  
  NSLog(@"didFinishLaunchingWithOptions>%@", launchOptions);
  
  OMNLaunchOptions *lo = [[OMNLaunchOptions alloc] initWithLaunchOptions:launchOptions];
  [OMNConstants setupWithLaunchOptions:lo completion:^{
    
    NSLog(@"config loaded");
    
    [[OMNAnalitics analitics] setup];
    
    [[OMNAuthorization authorisation] registerForRemoteNotificationsIfPossible];
    
    [[OMNBeaconBackgroundManager manager] setDidEnterBeaconsRegionBlock:^{
      
      [[OMNNearestBeaconSearchManager sharedManager] findNearestBeaconsWithCompletion:nil];
      
    }];
    
    [[OMNLaunchHandler sharedHandler] didFinishLaunchingWithOptions:lo];
    
  }];
  
  [self setupWindow];

  return YES;
  
}

- (void)setupWindow {
  
  [self setupAppearance];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.tintColor = [UIColor blackColor];
  
  OMNBackgroundVC *backgroundVC = [[OMNBackgroundVC alloc] init];
  backgroundVC.backgroundImage = [UIImage omn_imageNamed:@"LaunchImage-700"];
  self.window.rootViewController = backgroundVC;
  [self.window makeKeyAndVisible];
  
}

- (void)setupAppearance {
  
  [[UITextField appearance] setTintColor:colorWithHexString(@"157EFB")];
  
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
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  [[OMNAuthorization authorisation] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
  [OMNAnalitics analitics].deviceToken = deviceToken;

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  
  [[OMNAuthorization authorisation] application:application didFailToRegisterForRemoteNotificationsWithError:error];
  
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {

  [[OMNAuthorization authorisation] application:application didRegisterUserNotificationSettings:notificationSettings];
  
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  [[OMNLaunchHandler sharedHandler] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  [[OMNLaunchHandler sharedHandler] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  
  [[OMNLaunchHandler sharedHandler] didReceiveLocalNotification:notification];
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  
  [[OMNLaunchHandler sharedHandler] applicationWillEnterForeground];
  
}

@end
