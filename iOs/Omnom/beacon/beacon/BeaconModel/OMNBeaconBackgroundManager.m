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
#import "OMNConstants.h"
#import "OMNBeaconSearchManager.h"
#import "OMNDecodeBeacon.h"

static NSString * const kBackgroundBeaconIdentifier = @"kBackgroundBeaconIdentifier";

@interface OMNBeaconBackgroundManager()
<CLLocationManagerDelegate> {

  CLLocationManager *_locationManager;
  OMNBeaconSearchManager *_beaconSearchManager;
  
  UIBackgroundTaskIdentifier _searchBeaconTask;

}

@property (nonatomic, strong) CLBeaconRegion *backgroundBeaconRegion;
@property (nonatomic, strong) OMNBeacon *nearestBackgroundBeacon;
@property (nonatomic, strong) NSMutableDictionary *decodedBeacons;

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
    
    self.backgroundBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:kBeaconUUIDString] identifier:device_id];
    self.backgroundBeaconRegion.notifyOnEntry = YES;
    self.backgroundBeaconRegion.notifyOnExit = YES;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    
    if (kCLAuthorizationStatusAuthorized == [CLLocationManager authorizationStatus]) {
      [self startBeaconRegionMonitoring];
    }
    
  }
  return self;
}

- (NSString *)savedPath {
  NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  NSString *storedBeaconsPath = [documentsDirectory stringByAppendingPathComponent:@"storedBeacons.dat"];
  return storedBeaconsPath;
}

- (void)saveDecodedBeacons {
  [NSKeyedArchiver archiveRootObject:self.decodedBeacons toFile:[self savedPath]];
}

- (NSMutableDictionary *)decodedBeacons {
  
  if (nil == _decodedBeacons) {
    
    @try {
      _decodedBeacons = [NSKeyedUnarchiver unarchiveObjectWithFile:[self savedPath]];
    }
    @catch (NSException *exception) {
    }

    if (nil == _decodedBeacons) {
      _decodedBeacons = [NSMutableDictionary dictionary];
    }
    
  }
  
  return _decodedBeacons;
  
}

- (void)forgetFoundBeacons {
  [self.decodedBeacons removeAllObjects];
  [self saveDecodedBeacons];
}

- (void)beaconDidFind:(OMNBeacon *)beacon {
  
  if (nil == beacon) {
    return;
  }
  
  [_beaconSearchManager stop];
  _beaconSearchManager = nil;
  
  __weak typeof(self)weakSelf = self;
  [OMNDecodeBeacon decodeBeacons:@[beacon] success:^(NSArray *decodeBeacons) {
    
    OMNDecodeBeacon *decodeBeacon = [decodeBeacons firstObject];
    
    if (decodeBeacon) {
      [weakSelf showLocalPushWithBeacon:decodeBeacon];
    }
    
  } failure:^(NSError *error) {
  }];
  
  NSLog(@"beaconDidFind>%@", beacon);
  
}

- (BOOL)readyForPush:(OMNDecodeBeacon *)decodeBeacon {
  
  BOOL readyForPush = NO;
  OMNDecodeBeacon *savedBeacon = self.decodedBeacons[decodeBeacon.uuid];
  if (nil == savedBeacon ||
      savedBeacon.readyForPush) {
    readyForPush = YES;
    self.decodedBeacons[decodeBeacon.uuid] = decodeBeacon;
    [self saveDecodedBeacons];
  }
  
  return readyForPush;
  
}

- (void)showLocalPushWithBeacon:(OMNDecodeBeacon *)decodeBeacon {
  
  if ([self readyForPush:decodeBeacon]) {

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = decodeBeacon.restaurantId;
    localNotification.alertAction = NSLocalizedString(@"Запустить", nil);
    localNotification.soundName = @"Alert.caf";
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
  }
  [self stopBeaconSearchManagerTask];
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
//  [_locationManager requestStateForRegion:self.backgroundBeaconRegion];
  
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

  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
    case kCLAuthorizationStatusAuthorized:
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

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
  
  NSLog(@"monitoringDidFailForRegion>%@", error);
  
}

@end
