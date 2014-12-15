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

@interface OMNNearestBeaconsManager ()

@end

@implementation OMNNearestBeaconsManager {
  
  dispatch_semaphore_t _addBeaconLock;
  OMNNearestBeaconsBlock _didFindNearestBeaconsBlock;
  OMNBeaconRangingManager *_beaconRangingManager;
  CLAuthorizationStatusBlock _authorizationStatusBlock;
  void (^_failureBlock)(NSError *error);
}

- (void)dealloc {
  
  _authorizationStatusBlock = nil;
  [self stopRanging];
  _beaconRangingManager = nil;
  
}

- (instancetype)initWithStatusBlock:(CLAuthorizationStatusBlock)authorizationStatusBlock {
  self = [super init];
  if (self) {
    
    _foundBeacons = [[OMNFoundBeacons alloc] init];
    _authorizationStatusBlock = [authorizationStatusBlock copy];
    _addBeaconLock = dispatch_semaphore_create(1);
    _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithStatusBlock:authorizationStatusBlock];
    
  }
  return self;
}

- (void)findNearestBeacons:(OMNNearestBeaconsBlock)didFindNearestBeaconsBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSAssert(didFindNearestBeaconsBlock != nil, @"rangeNearestBeacons block shouldn't be nil");
  
  [self stopRanging];
  _didFindNearestBeaconsBlock = [didFindNearestBeaconsBlock copy];
  _failureBlock = [failureBlock copy];
  _startDate = [NSDate date];
  __weak typeof(self)weakSelf = self;
  [_beaconRangingManager rangeBeacons:^(NSArray *beacons) {
    
    [weakSelf processFoundBeacons:beacons];
    
  } failure:^(NSError *error) {
    
    [weakSelf processError:error];
    
  }];
  
}

- (void)stopRanging {
  
  _didFindNearestBeaconsBlock = nil;
  _isRanging = NO;
  [_beaconRangingManager stop];
  
}

- (void)processFoundBeacons:(NSArray *)newBeacons {
  
  dispatch_semaphore_wait(_addBeaconLock, DISPATCH_TIME_FOREVER);

  [_foundBeacons updateWithBeacons:newBeacons];
  
  NSArray *nearestBeacons = _foundBeacons.atTheTableBeacons;
  
  if (nearestBeacons.count) {
    
    _didFindNearestBeaconsBlock(_foundBeacons);
    _foundBeacons = [[OMNFoundBeacons alloc] init];
    
  }
  
  dispatch_semaphore_signal(_addBeaconLock);
  
}

- (void)processError:(NSError *)error {
  
  if (_failureBlock) {
    _failureBlock(error);
  }

}

@end
