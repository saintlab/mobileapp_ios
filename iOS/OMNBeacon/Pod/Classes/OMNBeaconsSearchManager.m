//
//  OMNBeaconsManager.m
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconsSearchManager.h"
#import "OMNBeaconRangingManager.h"
#import "OMNFoundBeacons.h"

@interface OMNBeaconsSearchManager ()

- (void)startSearching;
- (void)stop;

@end

NSString *generateRangingIdentifier() {

  CFUUIDRef uuidRef = CFUUIDCreate(NULL);
  CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
  CFRelease(uuidRef);
  NSString *uuid = (__bridge_transfer NSString *)uuidStringRef;
  return [NSString stringWithFormat:@"%@-%@.rangingTask", [[NSBundle mainBundle] bundleIdentifier], uuid];
  
}

@implementation OMNBeaconsSearchManager {
  
  CLLocationManager *_rangingManager;
  OMNFoundBeacons *_foundBeacons;
  NSTimer *_nearestBeaconsRangingTimer;
  NSArray *_rangingBeaconRegions;
  PMKFulfiller fulfiller;
  
}

+ (PMKPromise *)searchBeacons {
  
  OMNBeaconsSearchManager *manager = [[OMNBeaconsSearchManager alloc] init];
  PMKPromise *promise = [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    manager->fulfiller = fulfill;
    
  }];
  promise.finally(^{
    
    [manager stop];
    
  });
  [manager startSearching];
  return promise;
  
}

- (void)dealloc {
  [self stop];
}

- (void)startSearching {
  
  [self stop];
#if TARGET_IPHONE_SIMULATOR
  
  NSArray *beacons = @[[OMNBeacon demoBeacon]];
  [self processFoundBeacons:beacons];
  
#else
  
  [self rangeBeacons];
  
#endif
  
}

- (void)processFoundBeacons:(NSArray *)beacons {
  
  [self stop];
  if (fulfiller) {
    fulfiller(beacons);
    fulfiller = nil;
  }
  
}

- (void)beaconsNotFound {
  [self processFoundBeacons:@[]];
}

- (void)rangeBeacons {
  
  NSAssert([NSThread isMainThread], @"Should be run on main thread");
  
  if (![CLLocationManager isRangingAvailable] ||
      kCLAuthorizationStatusAuthorizedAlways != [CLLocationManager authorizationStatus]) {
    [self beaconsNotFound];
    return;
  }
  
  _nearestBeaconsRangingTimer = [NSTimer scheduledTimerWithTimeInterval:kBeaconSearchTimeout target:self selector:@selector(beaconsNotFound) userInfo:nil repeats:NO];
  _foundBeacons = [[OMNFoundBeacons alloc] init];
  
  _rangingManager = [[CLLocationManager alloc] init];
  _rangingManager.pausesLocationUpdatesAutomatically = NO;
  _rangingManager.delegate = self;

  _rangingBeaconRegions = [[OMNBeacon beaconUUID] aciveBeaconsRegionsWithIdentifier:generateRangingIdentifier()];
  [_rangingBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
    
    [_rangingManager startRangingBeaconsInRegion:beaconRegion];
    
  }];
  
}

- (void)stop {
  
  [_nearestBeaconsRangingTimer invalidate], _nearestBeaconsRangingTimer = nil;
  _rangingManager.delegate = nil;
  [_rangingBeaconRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *beaconRegion, NSUInteger idx, BOOL *stop) {
    
    [_rangingManager stopRangingBeaconsInRegion:beaconRegion];
    
  }];
  
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
  
  if (![_rangingBeaconRegions containsObject:region]) {
    return;
  }

  [_foundBeacons updateWithBeacons:beacons];
  if (_foundBeacons.readyForProcessing) {
    
    [self processFoundBeacons:_foundBeacons.allBeacons];
    
  }
  
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
  [self beaconsNotFound];
}

@end
