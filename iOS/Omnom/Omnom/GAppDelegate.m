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
#import <UAirship.h>
#import <UAConfig.h>
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
  
  NSLog(@"launchOptions>%@", launchOptions);
  
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
  
  [self setupUrbanAirship];
  [OMNOperationManager manager];
  [OMNAuthorisation authorisation];
  
  OMNStartVC *startVC = [[OMNStartVC alloc] init];
  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:startVC];
  
}

- (void)setupUrbanAirship {
  
  UAConfig *config = [UAConfig defaultConfig];
  [UAirship takeOff:config];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken>%@", deviceToken);
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

- (void)showSplash {
  
  _splashIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Splash"]];
  _splashIV.opaque = YES;
  [self.window addSubview:_splashIV];
  
}

- (void)hideSplash {
  
  [UIView animateWithDuration:0.5 animations:^{
    
    _splashIV.alpha = 0.0f;
    
  } completion:^(BOOL finished) {
    
    [_splashIV removeFromSuperview];
    _splashIV = nil;
    
  }];
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  
  NSLog(@"applicationWillEnterForeground");
  [self startApplication];
  
}

@end
