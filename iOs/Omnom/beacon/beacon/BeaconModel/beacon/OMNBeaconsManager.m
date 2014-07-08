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

@interface OMNBeaconsManager ()

@end

@implementation OMNBeaconsManager {
  
  dispatch_semaphore_t _addBeaconLock;

  OMNFoundBeaconsBlock _foundBeaconsBlock;
  OMNFoundBeaconsBlock _foundNearestBeaconsBlock;
  OMNBeaconsManagerStatusBlock _statusBlock;

  OMNBeaconRangingManager *_beaconRangingManager;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _addBeaconLock = dispatch_semaphore_create(1);
    _beaconRangingManager = [[OMNBeaconRangingManager alloc] init];
    
  }
  return self;
}

- (void)startMonitoringNearestBeacons:(OMNFoundBeaconsBlock)block status:(OMNBeaconsManagerStatusBlock)statusBlock {
  
  _ragingMonitorEnabled = YES;
  _foundNearestBeaconsBlock = block;
  _statusBlock = statusBlock;
  [self startRagingMonitoring];
  
}

- (void)startRagingMonitoring {
  
  if (!_ragingMonitorEnabled) {
    NSLog(@"Ranging is not avaliable");
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [_beaconRangingManager rangeNearestBeacons:^(NSArray *beacons) {
    
    [weakSelf processBeacons:beacons];
    
  } failure:^(NSError *error) {
    
    [weakSelf processError:error];
    
  } status:^(CLAuthorizationStatus status) {
    
    [weakSelf processStatus:status];
    
  }];
  
}

- (void)processBeacons:(NSArray *)newBeacons {
  
  dispatch_semaphore_wait(_addBeaconLock, DISPATCH_TIME_FOREVER);

  NSMutableArray *foundBeacons = [NSMutableArray arrayWithCapacity:newBeacons.count];
  [newBeacons enumerateObjectsUsingBlock:^(CLBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    [foundBeacons addObject:[beacon omn_beacon]];
    
  }];
  
  if (_foundBeaconsBlock) {
    
    _foundBeaconsBlock(foundBeacons);
    
  }
  
  [self findNearestBeacons:foundBeacons];
  
  dispatch_semaphore_signal(_addBeaconLock);
  
}

- (void)processError:(NSError *)error {
  
  NSLog(@"error>%@", error);
  
}

- (void)processStatus:(CLAuthorizationStatus)status {
  
  if (nil == _statusBlock) {
    return;
  }
  
  switch (status) {
    case kCLAuthorizationStatusRestricted: {
      _statusBlock(kBeaconsManagerStatusRestricted);
    } break;
    case kCLAuthorizationStatusDenied: {
      _statusBlock(kBeaconsManagerStatusDenied);
    } break;
    case kCLAuthorizationStatusNotDetermined: {
      _statusBlock(kBeaconsManagerStatusNotDetermined);
    } break;
    default: {
      _statusBlock(kBeaconsManagerStatusEnabled);
    } break;
  }
  
}

- (void)stopMonitoring {
  
  _foundBeaconsBlock = nil;
  _foundNearestBeaconsBlock = nil;
  _ragingMonitorEnabled = NO;
  [_beaconRangingManager stop];
  
}

- (void)findNearestBeacons:(NSArray *)beacons {
  
  if (nil == _foundNearestBeaconsBlock) {
    return;
  }
  
  OMNBeacon *nearestBeacon = [beacons firstObject];
  
  if (NO == nearestBeacon.nearTheTable) {
    return;
  }
  
  NSMutableArray *nearestBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
  [beacons enumerateObjectsUsingBlock:^(OMNBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    if ([beacon closeToBeacon:nearestBeacon]
        ) {
      [nearestBeacons addObject:beacon];
    }
    
  }];
  
  _foundNearestBeaconsBlock(nearestBeacons);
  
}

@end
