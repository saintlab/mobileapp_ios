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
  
  OMNNearestBeaconSearchManager *_nearestBeaconSearchManager;
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

- (CLLocationManager *)locationManager {
  
  if (nil == _locationManager) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.activityType = CLActivityTypeOther;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.delegate = self;
  }
#warning handle change state
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
    case kCLAuthorizationStatusAuthorizedAlways: {
      
      [self startBeaconRegionMonitoring];
      
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

  //TODO: send information to the server according device did enter to restaurant
  NSLog(@"===send information to the server according device did enter to restaurant");

  
  if (_nearestBeaconSearchManager) {
    NSLog(@"_beaconSearchManager already started");
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  _searchBeaconTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    
    [weakSelf stopBeaconSearchManagerTask];
    
  }];
  
  _nearestBeaconSearchManager = [[OMNNearestBeaconSearchManager alloc] init];
  [_nearestBeaconSearchManager findNearestBeacon:^(OMNBeacon *beacon, BOOL atTheTable) {
    
    [weakSelf beaconDidFind:beacon atTheTable:atTheTable];
    
  } failure:^{
    
    [weakSelf stopBeaconSearchManagerTask];
    
  }];
  
}


- (void)beaconDidFind:(OMNBeacon *)beacon atTheTable:(BOOL)atTheTable {
  
  if (self.didFindBeaconBlock) {
    
    __weak typeof(self)weakSelf = self;
    self.didFindBeaconBlock(beacon, atTheTable, ^{
      
      [weakSelf stopBeaconSearchManagerTask];
      
    });
    
  }
  else {
    
    [self stopBeaconSearchManagerTask];
    
  }
  
}

- (void)stopBeaconSearchManagerTask {
  
  [_nearestBeaconSearchManager stop];
  _nearestBeaconSearchManager = nil;
  
  if (UIBackgroundTaskInvalid != _searchBeaconTask) {
    
    NSLog(@"BeaconSearchManagerTask did finish");
    [[UIApplication sharedApplication] endBackgroundTask:_searchBeaconTask];
    _searchBeaconTask = UIBackgroundTaskInvalid;
    
  }
  
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
  
  NSLog(@"monitoringDidFailForRegion>%@", error);
  
}

@end
