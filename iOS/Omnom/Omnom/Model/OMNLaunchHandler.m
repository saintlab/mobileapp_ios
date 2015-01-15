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

- (instancetype)init {
  self = [super init];
  if (self) {
    
  }
  return self;
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

- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
  
  self.launchOptions = [[OMNLaunchOptions alloc] initWithLocanNotification:notification];
  [_startVC reloadSearchingRestaurant];
  
}

- (void)applicationWillEnterForeground {
  
  [self startApplicationIfNeeded];
  
}

@end
