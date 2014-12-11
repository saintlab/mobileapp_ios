
//
//  OMNBeaconRangingManager.m
//  beacon
//
//  Created by tea on 18.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconRangingManager.h"
#import "OMNBeacon.h"

@interface OMNBeaconRangingManager ()
<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *rangingLocationManager;

@end

@implementation OMNBeaconRangingManager {
  
  NSArray *_rangingBeaconRegions;
  
  CLBeaconsBlock _didRangeBeaconsBlock;
  
  void(^_didFailRangeBeaconsBlock)(NSError *);
}

- (void)dealloc {
  
  [self stop];
  _statusBlock = nil;
  _rangingLocationManager.delegate = nil;
  _rangingLocationManager = nil;

}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    NSString *identifier = [NSString stringWithFormat:@"%@.rangingTask", [[NSBundle mainBundle] bundleIdentifier]];
    _rangingBeaconRegions = [[OMNBeacon beaconUUID] aciveBeaconsRegionsWithIdentifier:identifier];
    _authorizationStatus = [CLLocationManager authorizationStatus];
    
  }
  return self;
}

- (instancetype)initWithStatusBlock:(CLAuthorizationStatusBlock)statusBlock {
  self = [self init];
  if (self) {

    _statusBlock = [statusBlock copy];
    [self rangingLocationManager];
    
  }
  return self;
}

- (CLLocationManager *)rangingLocationManager {
  if (nil == _rangingLocationManager) {
    
    _rangingLocationManager = [[CLLocationManager alloc] init];
    _rangingLocationManager.pausesLocationUpdatesAutomatically = NO;
    _rangingLocationManager.delegate = self;

  }
  return _rangingLocationManager;
}

- (void)rangeBeacons:(CLBeaconsBlock)didRangeBeaconsBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSAssert([NSThread isMainThread], @"Should be run on main thread");
  
  if (![CLLocationManager isRangingAvailable]) {
    
    if (failureBlock) {
      failureBlock(nil);
    }
    return;
  }
  
  _didRangeBeaconsBlock = [didRangeBeaconsBlock copy];
  _didFailRangeBeaconsBlock = [failureBlock copy];
  
  if (_ranging) {
    return;
  }
  
  [_rangingBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {

    [self.rangingLocationManager startRangingBeaconsInRegion:beaconRegion];
    
  }];
  _ranging = YES;
  
}

- (void)stop {
  
  _didRangeBeaconsBlock = nil;
  _didFailRangeBeaconsBlock = nil;
  
  [_rangingBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
    
    if ([self.rangingLocationManager.rangedRegions containsObject:beaconRegion]) {
      [self.rangingLocationManager stopRangingBeaconsInRegion:beaconRegion];
    }
    
  }];
  
  _ranging = NO;
  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  if (_statusBlock &&
      status != _authorizationStatus) {
    
    _statusBlock(status);
    
  }
  _authorizationStatus = status;
  
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
  
  if (_didRangeBeaconsBlock &&
      beacons.count) {
    
    _didRangeBeaconsBlock(beacons);
    
  }
    
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
  NSLog(@"rangingBeaconsDidFailForRegion>%@", error);
  if (_didFailRangeBeaconsBlock) {
    _didFailRangeBeaconsBlock(error);
  }
}

@end
