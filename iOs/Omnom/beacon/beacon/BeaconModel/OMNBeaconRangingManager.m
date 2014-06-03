
//
//  OMNBeaconRangingManager.m
//  beacon
//
//  Created by tea on 18.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconRangingManager.h"

@interface OMNBeaconRangingManager ()
<CLLocationManagerDelegate>

@end

@implementation OMNBeaconRangingManager {
  
  CLBeaconRegion *_rangingBeaconRegion;
  CLLocationManager *_rangingLocationManager;
  
  CLBeaconsBlock _didRangeNearestBeaconsBlock;
  CLAuthorizationStatusBlock _authorizationStatusBlock;
  OMNErrorBlock _didFailRangeBeaconsBlock;
  
}

- (void)dealloc {
  
  [self stop];
  
  _rangingLocationManager.delegate = nil;
  _rangingLocationManager = nil;

}

- (instancetype)init {
  self = [super init];
  if (self) {

    NSString *identifier = [NSString stringWithFormat:@"%@.rangingTask", [[NSBundle mainBundle] bundleIdentifier]];
    _rangingBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:kBeaconUUIDString] identifier:identifier];
    
    _rangingLocationManager = [[CLLocationManager alloc] init];
    _rangingLocationManager.delegate = self;
    
  }
  return self;
}

- (instancetype)initWithAuthorizationStatus:(CLAuthorizationStatusBlock)authorizationStatusBlock {
  
  self = [self init];
  if (self) {
    
    _authorizationStatusBlock = authorizationStatusBlock;
    
  }
  return self;
}

- (void)rangeNearestBeacons:(CLBeaconsBlock)didRangeNearestBeaconsBlock failure:(OMNErrorBlock)failureBlock {
  
  NSAssert([NSThread isMainThread], @"Should be run on main thread");
  
  
  if (![CLLocationManager isRangingAvailable]) {
    
    if (failureBlock) {
      failureBlock(nil);
    }
    return;
  }
  
  _didRangeNearestBeaconsBlock = didRangeNearestBeaconsBlock;
  _didFailRangeBeaconsBlock = failureBlock;
  
  if (![_rangingLocationManager.rangedRegions containsObject:_rangingBeaconRegion]) {
    [_rangingLocationManager startRangingBeaconsInRegion:_rangingBeaconRegion];
  }
  
}

- (void)stop {
  
  _didRangeNearestBeaconsBlock = nil;
  _didFailRangeBeaconsBlock = nil;
  
  if ([_rangingLocationManager.rangedRegions containsObject:_rangingBeaconRegion]) {
    [_rangingLocationManager stopRangingBeaconsInRegion:_rangingBeaconRegion];
  }
  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  if (_authorizationStatusBlock) {
    _authorizationStatusBlock(status);
  }
  
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
  
  if (_didRangeNearestBeaconsBlock) {
    _didRangeNearestBeaconsBlock(beacons);
  }
    
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
  
  if (_didFailRangeBeaconsBlock) {
    _didFailRangeBeaconsBlock(error);
  }
  
}

@end
