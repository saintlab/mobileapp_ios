//
//  OMNLaunchFactory.m
//  omnom
//
//  Created by tea on 17.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLaunchFactory.h"
#import "NSURL+omn_query.h"
#import "OMNQRLaunch.h"
#import "OMNBackgroundLaunch.h"
#import "OMNDefaultLaunch.h"
#import "OMNRemotePushLaunch.h"
#import "OMNTravelersLaunch.h"
#import "OMNTestLaunch.h"
#import "OMNDebugLaunch.h"

@implementation OMNLaunchFactory

+ (OMNLaunch *)launchWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

  NSDictionary *urlQuery = [url omn_query];
  NSString *customConfigName = urlQuery[@"omnom_config"];
  
  OMNLaunch *launch = nil;
  if (urlQuery[@"qr"]) {
    launch = [[OMNQRLaunch alloc] initWithQR:urlQuery[@"qr"] config:customConfigName];
  }
  else {
    launch = [[OMNDefaultLaunch alloc] initWithConfigName:customConfigName];
  }
  
  if ([url.host isEqualToString:@"wish"]) {
    launch.wishID = urlQuery[@"id"];
  }
  
  return launch;
  
}

+ (OMNLaunch *)decodeLaunchOptions:(NSDictionary *)launchOptions {

  if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
    
    return [[OMNBackgroundLaunch alloc] init];
    
  }
  else if (launchOptions[UIApplicationLaunchOptionsURLKey]) {
    
    return [self launchWithURL:launchOptions[UIApplicationLaunchOptionsURLKey] sourceApplication:nil annotation:nil];
    
  }
  else {
    
    return [[OMNDefaultLaunch alloc] init];
    
  }
  
}

+ (OMNLaunch *)launchWithLaunchOptions:(NSDictionary *)launchOptions {
  
#if OMN_TEST
  return [self decodeLaunchOptions:launchOptions];
#elif LUNCH_2GIS
  return [[OMNQRLaunch alloc] initWithQR:@"qr-code-for-0-lunch2gis" config:nil];
#elif LUNCH_2GIS_SUNCITY
  return [[OMNQRLaunch alloc] initWithQR:@"qr-code-for-0-lunch2gis-sun-city" config:@"config_staging"];
#elif OMN_TRAVELERS
  return [[OMNTravelersLaunch alloc] init];
#elif DEBUG
  return [OMNDebugLaunch new];
#else
  return [self decodeLaunchOptions:launchOptions];
#endif
  
}

+ (OMNLaunch *)launchWithLocalNotification:(UILocalNotification *)notification {
  return [[OMNDefaultLaunch alloc] init];
}

+ (OMNLaunch *)launchWithRemoteNotification:(NSDictionary *)notification {
  NSLog(@"launchWithRemoteNotification>%@", notification);
  return [[OMNRemotePushLaunch alloc] initWithRemoteNotification:notification];
}

@end
