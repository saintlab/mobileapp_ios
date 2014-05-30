//
//  OMNBeaconsManager.m
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconsManager.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNBeacon.h"
#import "CLBeacon+GBeaconAdditions.h"
#import "OMNBeaconRangingManager.h"
#import "OMNFoundBeacons.h"

NSString * const OMNBeaconsManagerDidChangeBeaconsNotification = @"OMNBeaconsManagerDidChangeBeaconsNotification";


@interface OMNBeaconsManager ()

/**
 This methos is used to sort and manage beacons coming from
 
 - (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
 delegate method
 @param newBeacons Array of CLBeacon objects
 */
- (void)addBeacons:(NSArray *)newBeacons;

@end

@implementation OMNBeaconsManager{
  
  dispatch_semaphore_t _addBeaconLock;

  BOOL _ragingMonitorEnabled;
  OMNFoundBeacons *_foundBeacons;
  OMNBeaconsManagerBlock _beaconsManagerBlock;
  OMNBeaconRangingManager *_beaconRangingManager;
}

@dynamic atTheTableBeacons;

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _addBeaconLock = dispatch_semaphore_create(1);
    _foundBeacons = [[OMNFoundBeacons alloc] init];
    
    __weak typeof(self)weakSelf = self;
    _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithAuthorizationStatus:^(CLAuthorizationStatus status) {
      
      switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusAuthorized: {
          
          [weakSelf startRagingMonitoring];
          
        } break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
          
          [weakSelf stopMonitoring];
          
        } break;
      }
      
    }];
    
  }
  return self;
}

- (NSMutableArray *)atTheTableBeacons {
  return _foundBeacons.atTheTableBeacons;
}

- (void)startMonitoring:(OMNBeaconsManagerBlock)block {
  
  _ragingMonitorEnabled = YES;
  _beaconsManagerBlock = block;
  [self startRagingMonitoring];
  
}

- (void)startRagingMonitoring {
  
  if (!_ragingMonitorEnabled) {
    NSLog(@"Ranging is not avaliable");
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [_beaconRangingManager rangeNearestBeacons:^(NSArray *beacons) {
    
    [weakSelf addBeacons:beacons];
    
  } failure:^{
  }];
  
}

- (void)stopMonitoring {
  
  _beaconsManagerBlock = nil;
  _ragingMonitorEnabled = NO;
  [_beaconRangingManager stop];
  
}

- (void)addBeacons:(NSArray *)newBeacons {
  
  dispatch_semaphore_wait(_addBeaconLock, DISPATCH_TIME_FOREVER);
  
  BOOL hasChanges = [_foundBeacons updateWithFoundBeacons:newBeacons];

  if (_beaconsManagerBlock) {
    _beaconsManagerBlock(self);
  }
  
  if (hasChanges) {
    
    dispatch_async(dispatch_get_main_queue(), ^{

      [[NSNotificationCenter defaultCenter] postNotificationName:OMNBeaconsManagerDidChangeBeaconsNotification object:self];
      
    });
    
  }

  dispatch_semaphore_signal(_addBeaconLock);
  
}

@end
