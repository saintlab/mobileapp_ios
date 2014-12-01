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
#import "OMNNearestBeaconSearchManager.h"

static NSString * const kBackgroundBeaconIdentifier = @"kBackgroundBeaconIdentifier";

@interface OMNBeaconBackgroundManager()
<CLLocationManagerDelegate> {
  
  OMNNearestBeaconSearchManager *_beaconSearchManager;
  UIBackgroundTaskIdentifier _searchBeaconTask;
  BOOL _monitoring;
  
}

@property (nonatomic, strong) NSArray *backgroundBeaconRegions;
@property (nonatomic, strong) NSArray *deprecatedBeaconRegions;
@property (nonatomic, strong) CLLocationManager *locationManager;

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
    
    [self startBeaconRegionMonitoring];
  }
  return self;
}

- (void)beaconDidFind:(OMNBeacon *)beacon {
  
  [_beaconSearchManager stop];
  _beaconSearchManager = nil;
  
  if (_didFindBeaconBlock) {
    
    __weak typeof(self)weakSelf = self;
    _didFindBeaconBlock(beacon, ^{
      
      [weakSelf stopBeaconSearchManagerTask];
      
    });
    
  }
  else {
    [self stopBeaconSearchManagerTask];
  }
  
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
  
  [self stopBeaconSearchManagerTask];
  
  //TODO: send information to the server according device did exit from restaurant, stop notification
  NSLog(@"send information to the server according device did exit from restaurant");
  
}

- (void)startBeaconRegionMonitoring {
  
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
  
  [_deprecatedBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
    
    if ([self.locationManager.monitoredRegions containsObject:beaconRegion]) {
      [self.locationManager stopMonitoringForRegion:beaconRegion];
    }
    
  }];
  
  if (_backgroundBeaconRegions.count) {
    _monitoring = YES;
  }
  
  [_backgroundBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
    
    if (NO == [self.locationManager.monitoredRegions containsObject:beaconRegion]) {
      [self.locationManager startMonitoringForRegion:beaconRegion];
    }
    
  }];
  
}

- (void)handlePush:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  if (_lookingForNearestBeacon) {
    completionHandler(UIBackgroundFetchResultNoData);
    return;
  }
  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
    case kCLAuthorizationStatusAuthorized:
    case kCLAuthorizationStatusNotDetermined: {
      
      [self startBeaconRegionMonitoring];
      
      //do nothig
    } break;
    default: {
      
      [self stopBeaconRegionMonitoring];
      
    } break;
  }
  
}

- (void)stopBeaconRegionMonitoring {
  
  if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
    _monitoring = NO;
    
    [_backgroundBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
      
      if ([self.locationManager.monitoredRegions containsObject:beaconRegion]) {
        [self.locationManager stopMonitoringForRegion:beaconRegion];
      }
      
    }];
    
    [_deprecatedBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
      
      if ([self.locationManager.monitoredRegions containsObject:beaconRegion]) {
        [self.locationManager stopMonitoringForRegion:beaconRegion];
      }
      
    }];
    
  }
  
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  NSLog(@"didEnterRegion>%@", region);
  
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
  NSLog(@"didExitRegion>%@", region);
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

- (void)handleDidEnterShopBeaconRegion {
  
  if (_beaconSearchManager) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  _searchBeaconTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    
    [weakSelf stopBeaconSearchManagerTask];
    
  }];
  
  _beaconSearchManager = [[OMNNearestBeaconSearchManager alloc] init];
  [_beaconSearchManager findNearestBeacon:^(OMNBeacon *beacon) {
    
    [weakSelf beaconDidFind:beacon];
    
  } failure:^{
    
    [weakSelf stopBeaconSearchManagerTask];
    
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

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
  
  NSLog(@"monitoringDidFailForRegion>%@", error);
  
}

@end
