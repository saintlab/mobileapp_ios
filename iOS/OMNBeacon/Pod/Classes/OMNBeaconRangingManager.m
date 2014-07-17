
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
  CLAuthorizationStatusBlock _statusBlock;
  
  void(^_didFailRangeBeaconsBlock)(NSError *);
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
    NSDictionary *beaconInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OMNBeaconUUID" ofType:@"plist"]];
    _rangingBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:beaconInfo[@"uuid"]] identifier:identifier];
    
    _rangingLocationManager = [[CLLocationManager alloc] init];
    _rangingLocationManager.delegate = self;
    
  }
  return self;
}

- (void)rangeNearestBeacons:(CLBeaconsBlock)didRangeNearestBeaconsBlock failure:(void (^)(NSError *error))failureBlock status:(CLAuthorizationStatusBlock)statusBlock {
  
  NSAssert([NSThread isMainThread], @"Should be run on main thread");
  
  if (![CLLocationManager isRangingAvailable]) {
    
    if (failureBlock) {
      failureBlock(nil);
    }
    return;
  }
  
  _didRangeNearestBeaconsBlock = didRangeNearestBeaconsBlock;
  _didFailRangeBeaconsBlock = failureBlock;
  _statusBlock = statusBlock;
  
  if (_ranging) {
    return;
  }
  
  if (![_rangingLocationManager.rangedRegions containsObject:_rangingBeaconRegion]) {
#ifdef __IPHONE_8_0
    if ([_rangingBeaconRegion respondsToSelector:@selector(requestAlwaysAuthorization)]) {
      [_rangingLocationManager requestAlwaysAuthorization];
    }
#endif
    [_rangingLocationManager startRangingBeaconsInRegion:_rangingBeaconRegion];
  }
  
  _ranging = YES;
  
}

- (void)stop {
  
  _didRangeNearestBeaconsBlock = nil;
  _didFailRangeBeaconsBlock = nil;
  _statusBlock = nil;
  
  if ([_rangingLocationManager.rangedRegions containsObject:_rangingBeaconRegion]) {
    [_rangingLocationManager stopRangingBeaconsInRegion:_rangingBeaconRegion];
  }
  _ranging = NO;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  NSLog(@"didChangeAuthorizationStatus>%d", status);
  if (_statusBlock) {
    _statusBlock(status);
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
