//
//  OMNBeaconsManager.m
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconsSearchManager.h"
#import "CBCentralManager+omn_promise.h"
#import "OMNBeaconRangingManager.h"
#import "OMNFoundBeacons.h"

@interface OMNBeaconsSearchManager ()

- (void)startSearching;
- (void)stop;

@end

@implementation OMNBeaconsSearchManager {
  
  OMNBeaconRangingManager *_beaconRangingManager;
  OMNFoundBeacons *_foundBeacons;
  NSTimer *_nearestBeaconsRangingTimer;
  
  PMKFulfiller fulfiller;
  PMKRejecter rejecter;
  
}

- (void)dealloc {
  [self stop];
}

+ (PMKPromise *)searchBeacons {
  
  OMNBeaconsSearchManager *manager = [[OMNBeaconsSearchManager alloc] init];
  PMKPromise *promise = [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {

    manager->fulfiller = fulfill;
    manager->rejecter = reject;
    
  }];
  promise.finally(^{
    
    [manager stop];
    
  });
  [manager startSearching];
  return promise;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _beaconRangingManager = [[OMNBeaconRangingManager alloc] init];
  }
  return self;
}


- (void)startSearching {
  
  [self stop];

  if (TARGET_IPHONE_SIMULATOR) {
    
    NSArray *beacons = @[[OMNBeacon demoBeacon]];
    [self processFoundBeacons:beacons];
    
  }
  else {
    
    [self checkCLStatus];
    
  }
  
}

- (void)processFoundBeacons:(NSArray *)beacons {
  
  [self stop];
  if (fulfiller) {
    fulfiller(beacons);
  }
  
}

- (void)checkCLStatus {
  
  CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
  if (kCLAuthorizationStatusAuthorizedAlways == authorizationStatus) {
    
    [self checkBluetoothState];
    
  }
  else {
    
    [self beaconsNotFound];
    
  }
  
}

- (void)checkBluetoothState {
  
  [CBCentralManager omn_getBluetoothState].then(^(NSNumber *state) {
    
    if (CBCentralManagerStatePoweredOn == [state integerValue]) {
      [self startRangingBeacons];
    }
    else {
      [self beaconsNotFound];
    }
    
  });
  
}

- (void)startRangingBeacons {
  
  if (_beaconRangingManager.ranging) {
    return;
  }
  
  if (!_beaconRangingManager.isRangingAvaliable) {
    [self beaconsNotFound];
    return;
  }
  
  _foundBeacons = [[OMNFoundBeacons alloc] init];
  _nearestBeaconsRangingTimer = [NSTimer scheduledTimerWithTimeInterval:kBeaconSearchTimeout target:self selector:@selector(didFailSearchingBeacons) userInfo:nil repeats:NO];
  
  __weak typeof(self)weakSelf = self;
  [_beaconRangingManager rangeBeacons:^(NSArray *beacons) {
    
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf didRangeBeacons:beacons];
    
  } failure:^(NSError *error) {
    
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf beaconsNotFound];
    
  }];
  
}

- (void)didRangeBeacons:(NSArray *)beacons {
  
  [_foundBeacons updateWithBeacons:beacons];
  if (_foundBeacons.readyForProcessing) {
    
    [self processFoundBeacons:_foundBeacons.allBeacons];
    
  }
  
}

- (void)beaconsNotFound {
  [self processFoundBeacons:@[]];
}

- (void)stop {

  [_nearestBeaconsRangingTimer invalidate], _nearestBeaconsRangingTimer = nil;
  [_beaconRangingManager stop];

}

@end
