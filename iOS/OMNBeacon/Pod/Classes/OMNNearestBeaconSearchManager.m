//
//  OMNBeaconSearchManager.m
//  beacon
//
//  Created by tea on 16.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNearestBeaconSearchManager.h"
#import <CoreLocation/CoreLocation.h>
#import "CLBeacon+GBeaconAdditions.h"
#import "OMNDevicePositionManager.h"
#import "OMNBeaconRangingManager.h"

NSTimeInterval const kBeaconSearchTimout = 5.0;

@interface OMNNearestBeaconSearchManager ()


@property (nonatomic, strong) CLBeaconRegion *rangingBeaconRegion;
@property (nonatomic, assign) UIBackgroundTaskIdentifier rangingBackgroundTaskIdentifier;

@end

@implementation OMNNearestBeaconSearchManager {
  
  OMNBeaconRangingManager *_beaconRangingManager;
  OMNDevicePositionManager *_devicePositionManager;
  void(^_didFindNearestBeaconBlock)(OMNBeacon *beacon, BOOL atTheTable);
  dispatch_block_t _failureBlock;
  UIBackgroundTaskIdentifier _searchBeaconTask;
  NSTimer *_beaconSearchTimeoutTimer;
}

- (void)dealloc {
  
  [self stop];
  
}

- (void)stop {
  
  [_beaconSearchTimeoutTimer invalidate], _beaconSearchTimeoutTimer = nil;
  
  _didFindNearestBeaconBlock = nil;
  _failureBlock = nil;

  [_devicePositionManager stop], _devicePositionManager = nil;
  [_beaconRangingManager stop], _beaconRangingManager = nil;
  
  if (UIBackgroundTaskInvalid != _searchBeaconTask) {
    
    [[UIApplication sharedApplication] endBackgroundTask:_searchBeaconTask];
    _searchBeaconTask = UIBackgroundTaskInvalid;
    
  }
  
}

- (void)findNearestBeacon:(void(^)(OMNBeacon *beacon, BOOL atTheTable))didFindNearestBeaconBlock failure:(dispatch_block_t)failureBlock {
  
  __weak typeof(self)weakSelf = self;
  _searchBeaconTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    
    [weakSelf stop];
    
  }];
  
  _didFindNearestBeaconBlock = [didFindNearestBeaconBlock copy];
  _failureBlock = [failureBlock copy];
  [self startRangingBeaconsAtTheTable:NO];
  
  _beaconSearchTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kBeaconSearchTimout target:self selector:@selector(didFailRangeBeacons) userInfo:nil repeats:NO];
  
}

- (void)startRangingBeaconsAtTheTable:(BOOL)atTheTable {
  
  [_devicePositionManager stop];
  _devicePositionManager = nil;
  
  __weak typeof(self)weakSelf = self;
  _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithStatusBlock:nil];
  
  [_beaconRangingManager rangeBeacons:^(NSArray *beacons) {
    
    [weakSelf didRangeBeacons:beacons atTheTable:atTheTable];
    
  } failure:^(NSError *error) {
    
    [weakSelf didFailRangeBeacons];
    
  }];
  
}

- (void)didRangeBeacons:(NSArray *)beacons atTheTable:(BOOL)atTheTable {
  
  if (0 == beacons.count) {
    return;
  }
  
  [_beaconSearchTimeoutTimer invalidate], _beaconSearchTimeoutTimer = nil;
  [_beaconRangingManager stop];
  _beaconRangingManager = nil;
  
  [beacons enumerateObjectsUsingBlock:^(CLBeacon *foundBeacon, NSUInteger idx, BOOL *stop) {
    NSLog(@"%@  %@  %@", foundBeacon.proximityUUID.UUIDString, foundBeacon.major, foundBeacon.minor);
  }];
  
  //according to documentation the nearest beacon is the first CLBeacon object in array
  CLBeacon *nearestBeacon = [beacons firstObject];
  OMNBeacon *omnBeacon = [nearestBeacon omn_beacon];
  
  if (_didFindNearestBeaconBlock) {
    _didFindNearestBeaconBlock(omnBeacon, atTheTable);
  }
  
  if (!atTheTable) {
    
    [self findBeaconsAtTheTable];
    
  }
  
}

- (void)findBeaconsAtTheTable {
  
  _devicePositionManager = [[OMNDevicePositionManager alloc] init];
  
  __weak typeof(self)weakSelf = self;
  [_devicePositionManager handleDeviceFaceUpPosition:^{
    
    [weakSelf startRangingBeaconsAtTheTable:YES];
    
  }];
  
}

- (void)didFailRangeBeacons {
  
  [_beaconRangingManager stop];
  _beaconRangingManager = nil;
  
  if (_failureBlock) {
    _failureBlock();
  }
  
}

@end
