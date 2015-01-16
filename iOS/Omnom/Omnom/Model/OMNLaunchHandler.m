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
  [[UIApplication sharedApplication].delegate window].rootViewController = [[UINavigationController alloc] initWithRootViewController:_startVC];
  
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  self.launchOptions = [[OMNLaunchOptions alloc] initWithURL:url sourceApplication:sourceApplication annotation:annotation];
  [_startVC reloadSearchingRestaurant];
  return YES;
  
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  NSLog(@"didReceiveRemoteNotification>%@", userInfo);
  completionHandler(UIBackgroundFetchResultNoData);
  NSString *open_url = userInfo[@"open_url"];
  if (open_url) {
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      [weakSelf openURL:[NSURL URLWithString:open_url]];
      
    });
    
  }
//  {"aps":{"sound":"new_guest.caf"}, "open_url" : "http://try.omnom.menu/mango"}
  
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
  
  [self startApplicationIfNeeded];
  
}

@end
