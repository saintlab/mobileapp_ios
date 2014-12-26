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
#import "OMNOperationManager.h"
#import "OMNStartVC.h"
#import "OMNVisitorManager.h"
#import <Crashlytics/Crashlytics.h>
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"
#import "OMNBackgroundVC.h"

@implementation GAppDelegate {
  
  BOOL _applicationStartedForeground;
  
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
#if OMN_TEST
  return YES;
#endif

  __weak typeof(self)weakSelf = self;
  [OMNConstants setupWithLaunchOptions:launchOptions completion:^{
    
    [[OMNAnalitics analitics] setup];
    
    [[OMNAuthorization authorisation] registerForRemoteNotificationsIfPossible];
    
    [[OMNBeaconBackgroundManager manager] setDidFindBeaconBlock:^(OMNBeacon *beacon, BOOL athTheTable, dispatch_block_t comletionBlock) {
      
      [[OMNVisitorManager manager] handleBackgroundBeacon:beacon
                                              athTheTable:athTheTable
                                           withCompletion:(athTheTable)?(comletionBlock):(nil)];
      
    }];
    
    BOOL applicationWasOpenedByBeacon = (launchOptions[UIApplicationLaunchOptionsLocationKey] != nil);
    if (NO == applicationWasOpenedByBeacon) {
      
      [weakSelf startApplicationIfNeededWithInfo:launchOptions];
      
    }
    
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

- (void)startApplicationIfNeededWithInfo:(NSDictionary *)info {

  if (_applicationStartedForeground) {
    return;
  }
  _applicationStartedForeground = YES;
  
  [Crashlytics startWithAPIKey:[OMNConstants crashlyticsAPIKey]];
  
  OMNStartVC *startVC = [[OMNStartVC alloc] init];
  startVC.info = info;
  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:startVC];
  
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
  NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken>%@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  
  [[OMNAuthorization authorisation] application:application didFailToRegisterForRemoteNotificationsWithError:error];
  
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {

  [[OMNAuthorization authorisation] application:application didRegisterUserNotificationSettings:notificationSettings];
  
}
#endif

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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  NSLog(@"didReceiveRemoteNotification>%@", userInfo);
  completionHandler(UIBackgroundFetchResultNoData);
  NSString *open_url = userInfo[@"open_url"];
  if (open_url) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:open_url]];
      
    });
    
  }
  
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  
  NSLog(@"didReceiveLocalNotification>%@", notification);
  if (notification.userInfo[OMNVisitorNotificationLaunchKey]) {
    
    [self startApplicationIfNeededWithInfo:notification.userInfo];
    
  }
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  
  NSLog(@"applicationWillEnterForeground");
  [self startApplicationIfNeededWithInfo:nil];
  
}

@end
