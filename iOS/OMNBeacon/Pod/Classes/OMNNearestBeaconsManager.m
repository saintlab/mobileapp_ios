//
//  OMNBeaconsManager.m
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNearestBeaconsManager.h"
#import "OMNBeacon.h"
#import "CLBeacon+GBeaconAdditions.h"
#import "OMNBeaconRangingManager.h"
#import "OMNFoundBeacons.h"

@interface OMNNearestBeaconsManager ()

@end

@implementation OMNNearestBeaconsManager {
  
  dispatch_semaphore_t _addBeaconLock;

  OMNFoundBeaconsBlock _foundNearestBeaconsBlock;

  OMNBeaconRangingManager *_beaconRangingManager;
  OMNBeaconsManagerStatusBlock _statusBlock;
}

- (void)dealloc {
  _statusBlock = nil;
  [self stop];
  _beaconRangingManager = nil;
}

- (instancetype)initWithStatusBlock:(OMNBeaconsManagerStatusBlock)statusBlock {
  self = [super init];
  if (self) {
    _statusBlock = statusBlock;
    _addBeaconLock = dispatch_semaphore_create(1);
    _beaconRangingManager = [[OMNBeaconRangingManager alloc] init];
    
  }
  return self;
}

- (void)rangeNearestBeacons:(OMNFoundBeaconsBlock)block {
  
  NSAssert(block != nil, @"rangeNearestBeacons block shouldn't be nil");
  
  [self stop];
  _isRanging = YES;
  _foundNearestBeaconsBlock = block;
  
  _beaconRangingManager.statusBlock = _statusBlock;
  
  __weak typeof(self)weakSelf = self;
  [_beaconRangingManager rangeBeacons:^(NSArray *beacons) {
    
    [weakSelf processBeacons:beacons];
    
  } failure:^(NSError *error) {
    
    [weakSelf processError:error];
    
  }];
  
}


- (void)stop {
  
  _foundNearestBeaconsBlock = nil;
  _isRanging = NO;
  [_beaconRangingManager stop];
  
}

- (void)processBeacons:(NSArray *)newBeacons {
  
  dispatch_semaphore_wait(_addBeaconLock, DISPATCH_TIME_FOREVER);

  NSMutableArray *foundBeacons = [NSMutableArray arrayWithCapacity:newBeacons.count];
  [newBeacons enumerateObjectsUsingBlock:^(CLBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    [foundBeacons addObject:[beacon omn_beacon]];
    
  }];
  
  [self findNearestBeacons:foundBeacons];
  
  dispatch_semaphore_signal(_addBeaconLock);
  
}

- (void)processError:(NSError *)error {
  
  NSLog(@"error>%@", error);
  
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
