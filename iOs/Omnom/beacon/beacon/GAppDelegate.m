//
//  GAppDelegate.m
//  beacon
//
//  Created by tea on 19.02.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GAppDelegate.h"
#import <UAirship.h>
#import <UAConfig.h>
#import <UAPush.h>
#import "OMNBeaconBackgroundManager.h"
#import "OMNBeaconSearchManager.h"
#import "OMNBeaconRangingManager.h"
#import "OMNBluetoothManager.h"
#import "OMNConstants.h"

@interface GAppDelegate ()
<CLLocationManagerDelegate>


@end

@implementation GAppDelegate {
  OMNBluetoothManager *_bm;
  OMNBeaconSearchManager *_beaconSearchManager;
  OMNBeaconRangingManager *_beaconRangingManager;
  
  CLLocationManager *_lm;
  
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
  NSLog(@"monitoringDidFailForRegion>%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
  
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"error>%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
  
  CLBeaconRegion *br = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:kBeaconUUIDString] identifier:@"1235"];
  [_lm startRangingBeaconsInRegion:br];
  if (status == kCLAuthorizationStatusNotDetermined) {
    
    
  }
  
  NSLog(@"CLAuthorizationStatus>%d", status);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  return YES;
  
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {
    
    NSLog(@"CBCentralManagerState>%d", state);
    
  }];

  
  _lm = [[CLLocationManager alloc] init];
  _lm.delegate = self;

  return YES;
  _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithAuthorizationStatus:^(CLAuthorizationStatus status) {
    
    NSLog(@"%d", status);
    
  }];
  
  
  [_beaconRangingManager rangeNearestBeacons:^(NSArray *beacons) {
    
NSLog(@"%@", beacons);
    
  } failure:^{
    
    NSLog(@"%@", @"errrr");
    
  }];
  
  
  
  
  
  
//  UAConfig *config = [UAConfig defaultConfig];
//  config.developmentLogLevel = UALogLevelError;
//  [UAirship takeOff:config];
//  
//  [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert);


  
//  _beaconSearchManager = [[OMNBeaconSearchManager alloc] init];
//  [_beaconSearchManager findNearestBeacon:^(OMNBeacon *beacon) {
//    
//    NSLog(@"findNearestBeacon> %@", beacon);
//    
//  } failure:^{
//    
//    NSLog(@"fail findNearestBeacon");
//    
//  }];
  
//  [OMNBeaconBackgroundManager manager];
  
//  _beaconRangingManager = [[OMNBeaconRangingManager alloc] init];
//  [_beaconRangingManager rangeNearestBeacons:^(NSArray *beacons) {
//    
//    [_beaconRangingManager stop];
//    
//  } failure:^{
//    
//    
//    
//  }];
  
  // Override point for customization after application launch.
  return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken>%@", deviceToken);
  
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  if ([userInfo[@"omn"] boolValue]) {
    
    [[OMNBeaconBackgroundManager manager] handlePush:userInfo fetchCompletionHandler:completionHandler];
    
  }
  else {
    
    completionHandler(UIBackgroundFetchResultNoData);
    
  }
  
  
  
  NSLog(@"didReceiveRemoteNotification2>%@", userInfo);
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  NSLog(@"applicationDidBecomeActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillResignActive:(UIApplication *)application {
  NSLog(@"applicationWillResignActive");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  NSLog(@"applicationWillEnterForeground");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
