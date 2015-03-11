//
//  OMNLaunchHandler.m
//  omnom
//
//  Created by tea on 10.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLaunchHandler.h"
#import <Crashlytics/Crashlytics.h>
#import "OMNStartVC.h"
#import "OMNModalWebVC.h"
#import "OMNNearestBeaconSearchManager.h"
#import "OMNNavigationControllerDelegate.h"

@implementation OMNLaunchHandler {
  
  OMNStartVC *_startVC;
  
}

+ (instancetype)sharedHandler {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (void)didFinishLaunchingWithOptions:(OMNLaunchOptions *)lo {
  
  _launchOptions = lo;
  if (!lo.applicationWasOpenedByBeacon) {
    
    [self startApplicationIfNeeded];
    
  }
  
}

- (void)startApplicationIfNeeded {
  
  if (_startVC) {
    return;
  }
  
  [Crashlytics startWithAPIKey:[OMNConstants crashlyticsAPIKey]];
  
  _startVC = [[OMNStartVC alloc] init];
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:_startVC];
  navVC.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  [[UIApplication sharedApplication].delegate window].rootViewController = navVC;
  
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  self.launchOptions = [[OMNLaunchOptions alloc] initWithURL:url sourceApplication:sourceApplication annotation:annotation];
  [_startVC reloadSearchingRestaurant];
  return YES;
  
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  DDLogDebug(@"didReceiveRemoteNotification>%@", userInfo);
  NSString *open_url = userInfo[@"open_url"];
  if (open_url) {
    
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      @strongify(self)
      [self openURL:[NSURL URLWithString:open_url]];
      
    });
    
  }
  
  NSString *type = userInfo[@"type"];
  
  if ([type isEqualToString:@"wake-up"]) {
    
    [[OMNNearestBeaconSearchManager sharedManager] findNearestBeaconsWithCompletion:^{
      
      completionHandler(UIBackgroundFetchResultNoData);
      
    }];
    
  }
  else if ([type isEqualToString:@"show_orders"] ||
           [type isEqualToString:@"lunch2gis"]) {
    
    if (UIApplicationStateActive != [UIApplication sharedApplication].applicationState) {
      
      self.launchOptions = [[OMNLaunchOptions alloc] initWithRemoteNotification:userInfo];
      [_startVC reloadSearchingRestaurant];
      
    }
    completionHandler(UIBackgroundFetchResultNoData);
    
  }
  else {
    
    completionHandler(UIBackgroundFetchResultNoData);
    
  }
  
}

- (void)openURL:(NSURL *)url {
  
  OMNModalWebVC *modalWebVC = [[OMNModalWebVC alloc] init];
  modalWebVC.url = url;
  UIViewController *topMostController = [self topMostController];
  modalWebVC.didCloseBlock = ^{
    
    [topMostController dismissViewControllerAnimated:YES completion:nil];
    
  };
  [topMostController presentViewController:[[UINavigationController alloc] initWithRootViewController:modalWebVC] animated:YES completion:nil];
  
}

- (UIViewController*)topMostController {
  
  UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
  while (topController.presentedViewController) {
    topController = topController.presentedViewController;
  }
  return topController;
  
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
  
  self.launchOptions = [[OMNLaunchOptions alloc] initWithLocanNotification:notification];
  [_startVC reloadSearchingRestaurant];
  
}

- (void)applicationWillEnterForeground {
  
  [Crashlytics setBoolValue:YES forKey:@"application_state_foreground"];
  [self startApplicationIfNeeded];
  
}

- (void)applicationDidEnterBackground {
  
  [Crashlytics setBoolValue:NO forKey:@"application_state_foreground"];
  
}

@end
