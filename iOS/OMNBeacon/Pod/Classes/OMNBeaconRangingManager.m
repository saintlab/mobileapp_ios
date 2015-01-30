
//
//  OMNBeaconRangingManager.m
//  beacon
//
//  Created by tea on 18.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconRangingManager.h"
#import "OMNBeacon.h"

NSTimeInterval const kBeaconSearchTimeout = 7.0;

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
  _rangingLocationManager.delegate = nil, _rangingLocationManager = nil;
  _statusBlock = nil;

}

+ (NSString *)generateIdentifier {
  
  CFUUIDRef uuidRef = CFUUIDCreate(NULL);
  CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
  CFRelease(uuidRef);
  NSString *uuid = (__bridge_transfer NSString *)uuidStringRef;
  return [NSString stringWithFormat:@"%@-%@.rangingTask", [[NSBundle mainBundle] bundleIdentifier], uuid];
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _rangingLocationManager = [[CLLocationManager alloc] init];
    _rangingLocationManager.pausesLocationUpdatesAutomatically = NO;
    
    NSString *identifier = [OMNBeaconRangingManager generateIdentifier];
    _rangingBeaconRegions = [[OMNBeacon beaconUUID] aciveBeaconsRegionsWithIdentifier:identifier];
    _authorizationStatus = [CLLocationManager authorizationStatus];
    
  }
  return self;
}

- (instancetype)initWithStatusBlock:(CLAuthorizationStatusBlock)statusBlock {
  self = [self init];
  if (self) {

    _statusBlock = [statusBlock copy];
    _rangingLocationManager.delegate = self;
    
  }
  return self;
}

- (BOOL)isRangingAvaliable {
  
  return [CLLocationManager isRangingAvailable];
  
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
  
  _rangingLocationManager.delegate = self;
  [_rangingBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {

    [_rangingLocationManager startRangingBeaconsInRegion:beaconRegion];
    
  }];
  _ranging = YES;
  
}

- (void)stop {
  
  _didRangeBeaconsBlock = nil;
  _didFailRangeBeaconsBlock = nil;
  [_rangingBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
    
    [_rangingLocationManager stopRangingBeaconsInRegion:beaconRegion];
    
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
  
  if ([_rangingBeaconRegions containsObject:region] &&
      _didRangeBeaconsBlock &&
      beacons.count) {
    
    _didRangeBeaconsBlock(beacons);
    
  }
  
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {

  if (![_rangingBeaconRegions containsObject:region]) {
    return;
  }
  
  if (_didFailRangeBeaconsBlock) {
    _didFailRangeBeaconsBlock(error);
  }
  [self stop];
  
}

@end
