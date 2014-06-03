//
//  OMNBeaconSearchManager.m
//  beacon
//
//  Created by tea on 16.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconSearchManager.h"
#import <CoreLocation/CoreLocation.h>
#import "CLBeacon+GBeaconAdditions.h"
#import "OMNDevicePositionManager.h"
#import "OMNBeaconRangingManager.h"

@interface OMNBeaconSearchManager ()


@property (nonatomic, strong) CLBeaconRegion *rangingBeaconRegion;
@property (nonatomic, assign) UIBackgroundTaskIdentifier rangingBackgroundTaskIdentifier;

@end

@implementation OMNBeaconSearchManager {
  
  OMNBeaconRangingManager *_beaconRangingManager;
  OMNDevicePositionManager *_devicePositionManager;
  
  OMNBeaconBlock _didFindNearestBeaconBlock;
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

- (void)findNearestBeacon:(OMNBeaconBlock)didFindNearestBeaconBlock failure:(dispatch_block_t)failureBlock {
  
  _didFindNearestBeaconBlock = didFindNearestBeaconBlock;
  _failureBlock = failureBlock;
  
  _devicePositionManager = [[OMNDevicePositionManager alloc] init];
  
  __weak typeof(self)weakSelf = self;
  [_devicePositionManager handleDeviceFaceUpPosition:^{
    
    NSLog(@"device is face up");
    dispatch_async(dispatch_get_main_queue(), ^{
    
      [weakSelf startRangingBeacons];
      
    });
    
  }];
  
}

- (void)startRangingBeacons {
  
  [_devicePositionManager stop];
  _devicePositionManager = nil;
  
  __weak typeof(self)weakSelf = self;
  _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithAuthorizationStatus:^(CLAuthorizationStatus status) {
    
    if (kCLAuthorizationStatusDenied == status) {
      
      [weakSelf didFailRangeBeacons];
      
    }
    
  }];
  
  
  [_beaconRangingManager rangeNearestBeacons:^(NSArray *beacons) {
    
    [weakSelf didRangeBeacons:beacons];
    
  } failure:^(NSError *error) {
    
    NSLog(@"error>%@", error);
    [weakSelf didFailRangeBeacons];
    
  }];
  
}

- (void)didRangeBeacons:(NSArray *)beacons {
  
  if (0 == beacons.count) {
    return;
  }
  
  [_beaconRangingManager stop];
  _beaconRangingManager = nil;
  
  NSLog(@"did found beacons");
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
