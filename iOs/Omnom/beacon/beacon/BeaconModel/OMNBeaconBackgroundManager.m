//
//  GBeaconBackgroundManager.m
//  beacon
//
//  Created by tea on 03.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconBackgroundManager.h"
#import <ESTBeaconManager.h>
#import <CoreLocation/CoreLocation.h>
#import "OMNBeacon.h"
#import "OMNConstants.h"
#import "OMNBeaconSearchManager.h"


static NSString * const kBackgroundBeaconIdentifier = @"kBackgroundBeaconIdentifier";

@interface OMNBeaconBackgroundManager()
<ESTBeaconDelegate,
ESTBeaconManagerDelegate,
CLLocationManagerDelegate> {

  CLLocationManager *_locationManager;
  OMNBeaconSearchManager *_beaconSearchManager;
  
  UIBackgroundTaskIdentifier _searchBeaconTask;
  
}

@property (nonatomic, strong) CLBeaconRegion *backgroundBeaconRegion;
@property (nonatomic, strong) OMNBeacon *nearestBackgroundBeacon;
@property (nonatomic, strong) NSMutableDictionary *foundBackgroundBeacons;

@end

@implementation OMNBeaconBackgroundManager

+ (instancetype)manager {
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
    
    self.foundBackgroundBeacons = [[NSMutableDictionary alloc] init];

    NSString *id = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_id"];
    if (nil == id) {
      
      CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
      id = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
      CFRelease(newUniqueId);
      [[NSUserDefaults standardUserDefaults] setObject:id forKey:@"device_id"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.backgroundBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:kBeaconUUIDString] identifier:id];
    self.backgroundBeaconRegion.notifyOnEntry = YES;
    self.backgroundBeaconRegion.notifyOnExit = YES;
    self.backgroundBeaconRegion.notifyEntryStateOnDisplay = YES;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
  }
  return self;
}

- (void)handleDidEnterShopBeaconRegion {

  if (_beaconSearchManager) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  _searchBeaconTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    
    [weakSelf stopBeaconSearchManagerTask];
    
  }];
  
  _beaconSearchManager = [[OMNBeaconSearchManager alloc] init];
  [_beaconSearchManager findNearestBeacon:^(OMNBeacon *beacon) {
    
    [weakSelf beaconDidFind:beacon];
    
  } failure:^{
    
    [weakSelf beaconDidFind:nil];
    
  }];
  
  //TODO: send information to the server according device did enter to restaurant
  NSLog(@"===send information to the server according device did enter to restaurant");
  
}

- (void)stopBeaconSearchManagerTask {
  
  [_beaconSearchManager stop];
  _beaconSearchManager = nil;
  
  if (UIBackgroundTaskInvalid != _searchBeaconTask) {
    
    [[UIApplication sharedApplication] endBackgroundTask:_searchBeaconTask];
    _searchBeaconTask = UIBackgroundTaskInvalid;
    
  }
  
}

- (void)beaconDidFind:(OMNBeacon *)beacon {
  
  [self stopBeaconSearchManagerTask];
  
  NSLog(@"beaconDidFind>%@", beacon);
  
}

- (void)handleDidExitShopBeaconRegion {
  
  [self stopBeaconSearchManagerTask];
  
  //TODO: send information to the server according device did exit from restaurant, stop notification
  NSLog(@"send information to the server according device did exit from restaurant");
  
}

- (void)addBeacon:(CLBeacon *)beacon {
  
  if (beacon.major == nil ||
      beacon.minor == nil) {
    return;
  }
  
}

- (void)startBeaconRegionMonitoring {
  
  if (NO == [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
    NSLog(@"This device does not support monitoring beacon regions");
    return;
  }
  
  [_locationManager startMonitoringForRegion:self.backgroundBeaconRegion];
  
  [_locationManager requestStateForRegion:self.backgroundBeaconRegion];
  
}

- (void)handlePush:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

//  if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//    return;
//  }
//  
  if (_lookingForNearestBeacon) {
    completionHandler(UIBackgroundFetchResultNoData);
    return;
  }

  [self handleDidEnterShopBeaconRegion];
  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
    case kCLAuthorizationStatusAuthorized:
    case kCLAuthorizationStatusNotDetermined: {
      
      [self startBeaconRegionMonitoring];
      
    } break;
    default: {
      
      [self stopBeaconRegionMonitoring];
      
    } break;
  }
  
}

- (void)stopBeaconRegionMonitoring {
  
  if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
    
    [_locationManager stopMonitoringForRegion:self.backgroundBeaconRegion];
    
  }
  
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
  
  // check if we found exactly our region
  if (NO == [self.backgroundBeaconRegion isEqual:region]) {
    return;
  }

  CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
  NSLog(@"didDetermineState>%ld for region>%@", (long)state, beaconRegion.proximityUUID.UUIDString);
  
  //doesn't handle foreground region monitoring
  if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
    NSLog(@"doesn't handle foreground region monitoring");
//    return;
  }
  
  switch (state) {
      
    case CLRegionStateInside: {

      [self handleDidEnterShopBeaconRegion];
      
    } break;
    case CLRegionStateOutside: {
      
      [self handleDidExitShopBeaconRegion];
      
    } break;
    case CLRegionStateUnknown: {
    } break;
      
  }
  
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
  
  NSLog(@"monitoringDidFailForRegion>%@", error);
  
}

@end
