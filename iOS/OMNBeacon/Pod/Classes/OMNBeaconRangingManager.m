
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

@property (nonatomic, strong) CLLocationManager *rangingLocationManager;

@end

@implementation OMNBeaconRangingManager {
  
  CLBeaconRegion *_rangingBeaconRegion;
  
  
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
    NSDictionary *beaconInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OMNBeaconUUID" ofType:@"plist"]];
    _rangingBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:beaconInfo[@"uuid"]] identifier:identifier];
    
  }
  return self;
}

- (instancetype)initWithStatusBlock:(CLAuthorizationStatusBlock)statusBlock {
  self = [self init];
  if (self) {

    _statusBlock = statusBlock;
    
  }
  return self;
}

- (CLLocationManager *)rangingLocationManager {
  if (nil == _rangingLocationManager) {
    _rangingLocationManager = [[CLLocationManager alloc] init];
    _rangingLocationManager.delegate = self;
    
    if ([_rangingLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
      [_rangingLocationManager performSelector:@selector(requestAlwaysAuthorization) withObject:nil];
    }
    
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
  
  _didRangeBeaconsBlock = didRangeBeaconsBlock;
  _didFailRangeBeaconsBlock = failureBlock;
  
  if (_ranging) {
    return;
  }
  
  if (![self.rangingLocationManager.rangedRegions containsObject:_rangingBeaconRegion]) {
    [self.rangingLocationManager startRangingBeaconsInRegion:_rangingBeaconRegion];
  }
  
  _ranging = YES;
  
}

- (void)stop {
  
  _didRangeBeaconsBlock = nil;
  _didFailRangeBeaconsBlock = nil;
  
  if ([self.rangingLocationManager.rangedRegions containsObject:_rangingBeaconRegion]) {
    [self.rangingLocationManager stopRangingBeaconsInRegion:_rangingBeaconRegion];
  }
  _ranging = NO;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  if (_statusBlock) {
    _statusBlock(status);
  }
  else {
    NSLog(@"didChangeAuthorizationStatus>%d", status);
  }
  
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
  
  if (_didRangeBeaconsBlock) {
    _didRangeBeaconsBlock(beacons);
  }
  else {
    NSLog(@"didRangeBeacons>%@", beacons);
  }
    
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
  NSLog(@"rangingBeaconsDidFailForRegion>%@", error);
  if (_didFailRangeBeaconsBlock) {
    _didFailRangeBeaconsBlock(error);
  }
  else {
    NSLog(@"rangingBeaconsDidFailForRegion>%@", error);
  }
}

@end
