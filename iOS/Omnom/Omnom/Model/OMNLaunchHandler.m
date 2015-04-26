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
#import "OMNLaunchFactory.h"
#import "OMNPaymentNotificationControl.h"

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

- (void)didFinishLaunchingWithOptions:(OMNLaunch *)lo {
  
  _launchOptions = lo;
  if (!lo.applicationStartedBackground) {
    
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

- (void)reloadWithLaunch:(OMNLaunch *)launch {
  [_startVC reloadWithLunch:launch];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  [self reloadWithLaunch:[OMNLaunchFactory launchWithURL:url sourceApplication:sourceApplication annotation:annotation]];
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
  

//  {"aps": {"sound":"default","alert":{"body":"Ваш заказ №1003 готов. Пинкод — 2036","action-loc-key":"Открыть приложение"}}}
  id alert = userInfo[@"aps"][@"alert"];
  NSString *text = nil;
  if ([alert isKindOfClass:[NSDictionary class]]) {
    text = alert[@"body"];
  }
  else if ([alert isKindOfClass:[NSString class]]) {
    text = alert;
  }
  if (text) {
    [[[UIAlertView alloc] initWithTitle:kOMN_PUSH_MESSAGE_TITLE message:text delegate:nil cancelButtonTitle:kOMN_OK_BUTTON_TITLE otherButtonTitles:nil] show];
  }
  
  if ([type isEqualToString:@"wake-up"]) {
    
    [[OMNNearestBeaconSearchManager sharedManager] findNearestBeaconsWithCompletion:^{
      
      completionHandler(UIBackgroundFetchResultNoData);
      
    }];
    
  }
  else if ([type isEqualToString:@"show_orders"] ||
           [type isEqualToString:@"lunch2gis"]) {
    
    if (UIApplicationStateActive != [UIApplication sharedApplication].applicationState) {
      
      [self reloadWithLaunch:[OMNLaunchFactory launchWithRemoteNotification:userInfo]];
      
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
    
    [topMostController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
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
  [self reloadWithLaunch:[OMNLaunchFactory launchWithLocalNotification:notification]];
}

- (void)applicationWillEnterForeground {
  
  [Crashlytics setBoolValue:YES forKey:@"application_state_foreground"];
  [self startApplicationIfNeeded];
  
}

- (void)applicationDidEnterBackground {
  [Crashlytics setBoolValue:NO forKey:@"application_state_foreground"];
}

@end
