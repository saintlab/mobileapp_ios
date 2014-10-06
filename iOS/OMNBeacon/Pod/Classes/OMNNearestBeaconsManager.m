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
#import "OMNFoundBeacons.h"

@interface OMNNearestBeaconsManager ()

@end

@implementation OMNNearestBeaconsManager {
  
  dispatch_semaphore_t _addBeaconLock;
  void (^_foundNearestBeaconsBlock)(NSArray *foundBeacons);
  OMNFoundBeacons *_foundBeacons;
  OMNBeaconRangingManager *_beaconRangingManager;
  CLAuthorizationStatusBlock _statusBlock;
  
}

- (void)dealloc {
  _statusBlock = nil;
  [self stop];
  _beaconRangingManager = nil;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSAssert(YES, @"call initWithStatusBlock: instead");
  }
  return self;
}

- (instancetype)initWithStatusBlock:(CLAuthorizationStatusBlock)statusBlock {
  self = [super init];
  if (self) {
    _foundBeacons = [[OMNFoundBeacons alloc] init];
    _statusBlock = statusBlock;
    _addBeaconLock = dispatch_semaphore_create(1);
    _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithStatusBlock:_statusBlock];
  }
  return self;
}

- (void)rangeNearestBeacons:(void (^)(NSArray *foundBeacons))block {
  
  NSAssert(block != nil, @"rangeNearestBeacons block shouldn't be nil");
  
  [self stop];
  _isRanging = YES;
  _foundNearestBeaconsBlock = block;
  
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

  [_foundBeacons updateWithBeacons:newBeacons];
  
  NSArray *nearestBeacons = _foundBeacons.atTheTableBeacons;
  
  if (nearestBeacons.count) {
    NSLog(@"nearestBeacons>%@", nearestBeacons);
    
    _foundNearestBeaconsBlock(nearestBeacons);
    _foundBeacons = [[OMNFoundBeacons alloc] init];
  }
  
  dispatch_semaphore_signal(_addBeaconLock);
  
}

- (void)processError:(NSError *)error {
//TODO:
}

@end
