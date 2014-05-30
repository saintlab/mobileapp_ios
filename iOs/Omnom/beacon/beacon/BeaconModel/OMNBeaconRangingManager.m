
//
//  OMNBeaconRangingManager.m
//  beacon
//
//  Created by tea on 18.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconRangingManager.h"
#import "OMNConstants.h"

static NSString * const kBeaconRangingIdentifier = @"kBeaconRangingIdentifier";

@interface OMNBeaconRangingManager ()
<CLLocationManagerDelegate>

@end

@implementation OMNBeaconRangingManager {
  
  CLBeaconRegion *_rangingBeaconRegion;
  CLLocationManager *_rangingLocationManager;
  
  CLBeaconsBlock _didRangeNearestBeaconsBlock;
  CLAuthorizationStatusBlock _authorizationStatusBlock;
  dispatch_block_t _didFailRangeBeaconsBlock;
  
}

- (void)dealloc {
  
  [self stop];
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _rangingBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:kBeaconUUIDString] identifier:kBeaconRangingIdentifier];
    
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

- (void)rangeNearestBeacons:(CLBeaconsBlock)didRangeNearestBeaconsBlock failure:(dispatch_block_t)failureBlock {
  
  NSAssert([NSThread isMainThread], @"Should be run on main thread");
  
  if (![CLLocationManager isRangingAvailable] ||
      [_rangingLocationManager.rangedRegions containsObject:_rangingBeaconRegion]) {
    
    if (failureBlock) {
      failureBlock();
    }
    return;
  }
  
  _didRangeNearestBeaconsBlock = didRangeNearestBeaconsBlock;
  _didFailRangeBeaconsBlock = failureBlock;
  
  [_rangingLocationManager startRangingBeaconsInRegion:_rangingBeaconRegion];
  
}

- (void)stop {
  
  _didRangeNearestBeaconsBlock = nil;
  _didFailRangeBeaconsBlock = nil;
  
  _rangingLocationManager.delegate = nil;
  if ([_rangingLocationManager.rangedRegions containsObject:_rangingBeaconRegion]) {
    [_rangingLocationManager stopRangingBeaconsInRegion:_rangingBeaconRegion];
  }
  _rangingLocationManager = nil;
  
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
    _didFailRangeBeaconsBlock();
  }
  
}

@end
