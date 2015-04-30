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
#import "OMNNavigationController.h"
#import "OMNLaunchFactory.h"
#import "OMNPaymentNotificationControl.h"
#import "OMNWishInfoVC.h"
#import "OMNConstants.h"
#import "NSURL+omn_query.h"
#import "OMNDefaultLaunch.h"

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

- (void)startApplicationIfNeeded {

  if (_startVC) {
    return;
  }
  
  [Crashlytics startWithAPIKey:[OMNConstants crashlyticsAPIKey]];
  _startVC = [[OMNStartVC alloc] init];
  UIWindow *window = [[UIApplication sharedApplication].delegate window];
  window.rootViewController = [OMNNavigationController controllerWithRootVC:_startVC];
  [window makeKeyAndVisible];

}

- (void)reload {
  [self reloadWithLaunch:[OMNDefaultLaunch new]];
}

- (void)reloadWithLaunch:(OMNLaunch *)launch {
  
  _launch = launch;
  
  if (launch.applicationStartedBackground) {
    return;
  }

  if (_startVC &&
      launch.shouldReload) {
    
    [_startVC reload];
    
  }

  [self startApplicationIfNeeded];

  if (launch.wishID) {
    [self showWishWithID:launch.wishID];
  }
  
  if (launch.openURL) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      [self showModalControllerWithURL:launch.openURL];
      
    });

  }
  
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  [self reloadWithLaunch:[OMNLaunchFactory launchWithURL:url sourceApplication:sourceApplication annotation:annotation]];
  return YES;
  
}

- (void)showWishWithID:(NSString *)wishID {
  
  if (![wishID isKindOfClass:[NSString class]]) {
    return;
  }
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    OMNWishInfoVC *wishInfoVC = [[OMNWishInfoVC alloc] initWithWishID:wishID];
    [wishInfoVC show:[self topMostController]];
    
  });
  
}

- (void)showAlertWithInfoIfNeeded:(NSDictionary *)info {
  
  //  {"aps": {"sound":"default","alert":{"body":"Ваш заказ №1003 готов. Пинкод — 2036","action-loc-key":"Открыть приложение"}}}
  id alert = info[@"aps"][@"alert"];
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
  
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  DDLogDebug(@"didReceiveRemoteNotification>%@", userInfo);
  NSString *type = userInfo[@"type"];
  if ([type isEqualToString:@"wake-up"]) {
    
    [[OMNNearestBeaconSearchManager sharedManager] findNearestBeaconsWithCompletion:^{
      
      completionHandler(UIBackgroundFetchResultNoData);
      
    }];
    
  }
  else {
    
    [self reloadWithLaunch:[OMNLaunchFactory launchWithRemoteNotification:userInfo]];
    completionHandler(UIBackgroundFetchResultNoData);
    
  }
  
}

- (void)showModalControllerWithURL:(NSURL *)url {
  
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
