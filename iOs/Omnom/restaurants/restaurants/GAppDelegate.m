//
//  GAppDelegate.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GAppDelegate.h"
#import "OMNAuthorisation.h"
#import "OMNFuturaAssetManager.h"
#import "OMNStartVC.h"
#import "OMNBeaconBackgroundManager.h"
#import <UAirship.h>
#import <UAConfig.h>
#import "OMNDemoVC.h"

@interface GAppDelegate ()


@end

@implementation GAppDelegate {
  UIImageView *_splashIV;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [self setupUrbanAirship];
  
  [OMNAssetManager updateWithManager:[OMNFuturaAssetManager new]];
  
  [OMNAuthorisation authorisation];
  
  [OMNBeaconBackgroundManager manager];
  
  OMNStartVC *startVC = [[OMNStartVC alloc] init];
  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:startVC];
  
//  self.window.rootViewController = [[OMNDemoVC alloc] init];
  
  return YES;
  
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

@end
