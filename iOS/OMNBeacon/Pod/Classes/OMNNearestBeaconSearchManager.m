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

@interface OMNNearestBeaconSearchManager ()


@property (nonatomic, strong) CLBeaconRegion *rangingBeaconRegion;
@property (nonatomic, assign) UIBackgroundTaskIdentifier rangingBackgroundTaskIdentifier;

@end

@implementation OMNNearestBeaconSearchManager {
  
  OMNBeaconRangingManager *_beaconRangingManager;
  OMNDevicePositionManager *_devicePositionManager;
  void(^_didFindNearestBeaconBlock)(OMNBeacon *beacon);
  dispatch_block_t _failureBlock;
  
}

- (void)dealloc {

}

- (void)stop {
  
  _didFindNearestBeaconBlock = nil;
  _failureBlock = nil;

  [_devicePositionManager stop], _devicePositionManager = nil;
  [_beaconRangingManager stop], _beaconRangingManager = nil;
  
}

- (void)findNearestBeacon:(void(^)(OMNBeacon *beacon))didFindNearestBeaconBlock failure:(dispatch_block_t)failureBlock {
  
  _didFindNearestBeaconBlock = [didFindNearestBeaconBlock copy];
  _failureBlock = [failureBlock copy];

  _devicePositionManager = [[OMNDevicePositionManager alloc] init];
  
  __weak typeof(self)weakSelf = self;
  [_devicePositionManager handleDeviceFaceUpPosition:^{
    
    [weakSelf startRangingBeacons];
    
  }];
  
}

- (void)startRangingBeacons {

  [_devicePositionManager stop];
  _devicePositionManager = nil;
  
  __weak typeof(self)weakSelf = self;
  _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithStatusBlock:nil];
  
  [_beaconRangingManager rangeBeacons:^(NSArray *beacons) {
    
    [weakSelf didRangeBeacons:beacons];
    
  } failure:^(NSError *error) {
    
    [weakSelf didFailRangeBeacons];
    
  }];
  
}

- (void)didRangeBeacons:(NSArray *)beacons {
  
  NSLog(@"did found beacons>%@", beacons);
  
  if (0 == beacons.count) {
    return;
  }
  
  [_beaconRangingManager stop];
  _beaconRangingManager = nil;
  
  [beacons enumerateObjectsUsingBlock:^(CLBeacon *foundBeacon, NSUInteger idx, BOOL *stop) {
    NSLog(@"%@  %@  %@", foundBeacon.proximityUUID.UUIDString, foundBeacon.major, foundBeacon.minor);
  }];
  
  //according to documentation the nearest beacon is the first CLBeacon object in array
  CLBeacon *nearestBeacon = [beacons firstObject];
  OMNBeacon *omnBeacon = [nearestBeacon omn_beacon];
  
  if (_didFindNearestBeaconBlock) {
    _didFindNearestBeaconBlock(omnBeacon);
  }
  
}

- (void)didFailRangeBeacons {
  
  [_beaconRangingManager stop];
  _beaconRangingManager = nil;
  
  if (_failureBlock) {
    _failureBlock();
  }
  
}

@end
