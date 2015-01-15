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
#import "OMNBeaconRangingManager.h"
#import "OMNFoundBeacons.h"
#import "OMNBluetoothManager.h"

@interface OMNNearestBeaconSearchManager ()


@property (nonatomic, strong) CLBeaconRegion *rangingBeaconRegion;
@property (nonatomic, assign) UIBackgroundTaskIdentifier rangingBackgroundTaskIdentifier;

@end

@implementation OMNNearestBeaconSearchManager {
  
  OMNBeaconRangingManager *_beaconRangingManager;
  OMNDidFindNearestBeaconBlock _didFindNearestBeaconBlock;
  dispatch_block_t _failureBlock;
  UIBackgroundTaskIdentifier _searchBeaconTask;
  NSTimer *_beaconRangingTimeoutTimer;
  OMNFoundBeacons *_foundBeacons;
  
}

- (void)dealloc {
  
  [self stop];
  
}

- (void)stopRangingBeacons {
  
  [_beaconRangingTimeoutTimer invalidate], _beaconRangingTimeoutTimer = nil;
  [_beaconRangingManager stop], _beaconRangingManager = nil;
  
}

- (void)stop {
  
  [self stopRangingBeacons];
  
  _didFindNearestBeaconBlock = nil;
  _failureBlock = nil;

  if (UIBackgroundTaskInvalid != _searchBeaconTask) {
    
    [[UIApplication sharedApplication] endBackgroundTask:_searchBeaconTask];
    _searchBeaconTask = UIBackgroundTaskInvalid;
    
  }
  
}

- (void)didFail {
  
  if (_failureBlock) {
    
    _failureBlock();
    
  }
  [self stop];
  
}

- (void)findNearestBeacons:(OMNDidFindNearestBeaconBlock)didFindNearestBeaconBlock failure:(dispatch_block_t)failureBlock {

  [self stop];
  _didFindNearestBeaconBlock = [didFindNearestBeaconBlock copy];
  _failureBlock = [failureBlock copy];
  
  __weak typeof(self)weakSelf = self;
  _searchBeaconTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    
    [weakSelf didFail];
    
  }];
  
  if (![CLLocationManager isRangingAvailable]) {
    [self didFail];
    return;
  }
  
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {

    if (state == CBCentralManagerStatePoweredOn) {
      
      [weakSelf startRangingBeacons];
      
    }
    else {
      
      [weakSelf didFail];
      
    }
    
  }];
  
  
}

- (void)startRangingBeacons {
  
  _foundBeacons = [[OMNFoundBeacons alloc] init];
  _beaconRangingTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kBeaconSearchTimeout target:self selector:@selector(didFail) userInfo:nil repeats:NO];
  __weak typeof(self)weakSelf = self;
  _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithStatusBlock:nil];
  
  [_beaconRangingManager rangeBeacons:^(NSArray *beacons) {
    
    [weakSelf didRangeBeacons:beacons];
    
  } failure:^(NSError *error) {
    
    [weakSelf didFail];
    
  }];
  
}


- (void)didRangeBeacons:(NSArray *)beacons {

  [_foundBeacons updateWithBeacons:beacons];
  
  if (_foundBeacons.readyForProcessing) {
    
    [self didFoundBeacons];
    
  }
  
}

- (void)didFoundBeacons {
  
  [self stopRangingBeacons];
  if (_didFindNearestBeaconBlock) {
    
    _didFindNearestBeaconBlock(_foundBeacons.allBeacons);
    
  }
  
  [self stop];

}

@end
