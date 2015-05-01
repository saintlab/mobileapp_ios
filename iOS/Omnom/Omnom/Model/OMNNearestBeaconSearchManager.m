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
#import <CBCentralManager+omn_promise.h>
#import "OMNRestaurantManager.h"

@interface OMNNearestBeaconSearchManager ()


@property (nonatomic, strong) CLBeaconRegion *rangingBeaconRegion;
@property (nonatomic, strong) OMNFoundBeacons *foundBeacons;
@property (nonatomic, assign) UIBackgroundTaskIdentifier rangingBackgroundTaskIdentifier;

@end

@implementation OMNNearestBeaconSearchManager {
  
  OMNBeaconRangingManager *_beaconRangingManager;
  dispatch_block_t _didFindNearestBeaconBlock;
  UIBackgroundTaskIdentifier _searchBeaconTask;
  NSTimer *_beaconRangingTimeoutTimer;
  
}

+ (instancetype)sharedManager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithStatusBlock:nil];
    
  }
  return self;
}

- (void)stopRangingBeacons {
  
  [_beaconRangingTimeoutTimer invalidate], _beaconRangingTimeoutTimer = nil;
  [_beaconRangingManager stop];
  
}

- (void)stop {
  
  [self stopRangingBeacons];
  
  if (UIBackgroundTaskInvalid != _searchBeaconTask) {
    
    DDLogDebug(@"did finish background ranging");
    [[UIApplication sharedApplication] endBackgroundTask:_searchBeaconTask];
    _searchBeaconTask = UIBackgroundTaskInvalid;
    
  }
  
}

- (void)didFinish {
  
  [self stop];
  if (_didFindNearestBeaconBlock) {
    
    _didFindNearestBeaconBlock();
    _didFindNearestBeaconBlock = nil;
    
  }
  
}

- (void)findNearestBeaconsWithCompletion:(dispatch_block_t)didFindNearestBeaconBlock {

  if (_beaconRangingManager.ranging) {
    
    if (didFindNearestBeaconBlock) {
      didFindNearestBeaconBlock();
    }
    return;
    
  }
  
  @weakify(self)
  _searchBeaconTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    
    @strongify(self)
    [self didFinish];
    
  }];

  [self stopRangingBeacons];

  _didFindNearestBeaconBlock = [didFindNearestBeaconBlock copy];
  
  
  if (![CLLocationManager isRangingAvailable]) {
    [self didFinish];
    return;
  }
  
  [CBCentralManager omn_getBluetoothState].then(^(NSNumber *state) {
    
    if (CBCentralManagerStatePoweredOn == [state integerValue]) {
      [self startRangingBeacons];
    }
    else {
      [self didFinish];
    }
    
  });
  
}

- (void)startRangingBeacons {
  
  self.foundBeacons = [[OMNFoundBeacons alloc] init];
  
  @weakify(self)
  _beaconRangingTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kBeaconSearchTimeout target:self selector:@selector(didFinish) userInfo:nil repeats:NO];
  [_beaconRangingManager rangeBeacons:^(NSArray *beacons) {
    
    @strongify(self)
    [self.foundBeacons updateWithBeacons:beacons];
    if (self.foundBeacons.readyForProcessing) {
      [self didFoundBeacons];
    }
    
  } failure:^(NSError *error) {
    
    @strongify(self)
    [self didFinish];
    
  }];
  
}

- (void)didFoundBeacons {
  
  [self stopRangingBeacons];
  NSArray *nearestBeacons = self.foundBeacons.allBeacons;
  @weakify(self)
  [[OMNRestaurantManager sharedManager] handleBackgroundBeacons:nearestBeacons withCompletion:^{
    
    @strongify(self)
    [self didFinish];
    
  }];

}

@end
