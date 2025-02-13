//
//  GBeaconBackgroundManager.m
//  beacon
//
//  Created by tea on 03.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconBackgroundManager.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNBeacon.h"
#import "CBCentralManager+omn_promise.h"

@interface OMNBeaconBackgroundManager()
<CLLocationManagerDelegate> {
  
  BOOL _monitoring;
  
}

@property (nonatomic, strong) NSArray *backgroundBeaconRegions;
@property (nonatomic, strong) NSArray *deprecatedBeaconRegions;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation OMNBeaconBackgroundManager

+ (instancetype)manager {
  
#if LUNCH_2GIS
  return nil;
#elif LUNCH_2GIS_SUNCITY
  return nil;
#endif
  
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
    
    NSString *device_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_id"];
    if (nil == device_id) {
      
      CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
      device_id = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
      CFRelease(newUniqueId);
      [[NSUserDefaults standardUserDefaults] setObject:device_id forKey:@"device_id"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }

    NSMutableArray *backgroundBeaconRegions = [NSMutableArray array];
    OMNBeaconUUID *beaconUUID = [OMNBeacon beaconUUID];
    
    _backgroundBeaconRegions = [[OMNBeacon beaconUUID] aciveBeaconsRegionsWithIdentifier:device_id];
    _deprecatedBeaconRegions = [[OMNBeacon beaconUUID] deprecatedBeaconsRegionsWithIdentifier:device_id];
    
    [self locationManager];
    
  }
  return self;
}

- (CLLocationManager *)locationManager {
  
  if (nil == _locationManager) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.activityType = CLActivityTypeOther;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.delegate = self;
  }
  return _locationManager;
  
}


- (void)handleDidExitShopBeaconRegion {
  
  //TODO: send information to the server according device did exit from restaurant, stop notification
  NSLog(@"send information to the server according device did exit from restaurant");
  
}

- (void)startBeaconRegionMonitoringIfPossible {
  
  if (kCLAuthorizationStatusAuthorized != [CLLocationManager authorizationStatus]) {
    return;
  }

  if (_monitoring) {
    return;
  }

  if (NO == [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
    NSLog(@"This device does not support monitoring beacon regions");
    return;
  }

  [CBCentralManager omn_bluetoothEnabled].then(^{
    
    [self startBeaconRegionMonitoring];

  });
  
}

- (void)startBeaconRegionMonitoring {
  
  [_deprecatedBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
    
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    
  }];
  
  if (_backgroundBeaconRegions.count) {
    _monitoring = YES;
  }
  
  [_backgroundBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
    
  }];
  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
    case kCLAuthorizationStatusAuthorizedAlways: {
      
      [self startBeaconRegionMonitoringIfPossible];
      
    } break;
    case kCLAuthorizationStatusNotDetermined: {
      //do nothig
    } break;
    default: {
      
      [self stopBeaconRegionMonitoring];
      
    } break;
  }
  
}

- (void)stopBeaconRegionMonitoring {
  
  _monitoring = NO;
  if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
    return;
  }
  
  [_backgroundBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
    
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    
  }];
  
  [_deprecatedBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
    
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    
  }];
  
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {

  // check if we found exactly our region
  if (NO == [self.backgroundBeaconRegions containsObject:region]) {
    return;
  }

  CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
  NSLog(@"didDetermineState>%ld for region>%@", (long)state, beaconRegion.proximityUUID.UUIDString);
  
  //doesn't handle foreground region monitoring
  if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
    NSLog(@"doesn't handle foreground region monitoring");
    return;
  }

  UIBackgroundTaskIdentifier backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
  }];

  if (CLRegionStateInside == state) {
    [self handleDidEnterShopBeaconRegion];
  }
  
  [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
  backgroundTaskIdentifier = UIBackgroundTaskInvalid;
  
}

- (void)handleDidEnterShopBeaconRegion {

  if (self.didEnterBeaconsRegionBlock) {
    self.didEnterBeaconsRegionBlock();
  }
  
}

@end
