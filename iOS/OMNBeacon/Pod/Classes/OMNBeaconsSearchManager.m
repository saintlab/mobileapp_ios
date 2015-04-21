//
//  OMNBeaconsManager.m
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconsSearchManager.h"
#import "OMNBluetoothManager.h"
#import "OMNBeaconRangingManager.h"

@implementation OMNBeaconsSearchManager {
  
  OMNBeaconRangingManager *_beaconRangingManager;
  OMNFoundBeacons *_foundBeacons;
  NSTimer *_nearestBeaconsRangingTimer;
  OMNDidFindBeaconsBlock _didFindBeaconsBlock;
  
}

- (void)dealloc {
  [self stop];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    __weak typeof(self)weakSelf = self;
    _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithStatusBlock:^(CLAuthorizationStatus status) {
      
      if (kCLAuthorizationStatusAuthorizedAlways != status) {
        
        [weakSelf didFailSearchingBeacons];
        
      }
      
    }];
    
  }
  return self;
}


- (void)startSearchingWithCompletion:(OMNDidFindBeaconsBlock)didFindBeaconsBlock {
  
  _didFindBeaconsBlock = [didFindBeaconsBlock copy];
  
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
  _didFindBeaconsBlock(beacons);
  _didFindBeaconsBlock = nil;
  
}

- (void)didFailSearchingBeacons {
  [self processFoundBeacons:nil];
}

- (void)checkCLStatus {
  
  CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
  if (kCLAuthorizationStatusAuthorizedAlways == authorizationStatus) {
    
    [self checkBluetoothState];
    
  }
  else {
    
    [self didFailSearchingBeacons];
    
  }
  
}

- (void)checkBluetoothState {
  
  __weak typeof(self)weakSelf = self;
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {
    
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    switch (state) {
      case CBCentralManagerStatePoweredOn: {
        
        [strongSelf startRangingBeacons];
        
      } break;
      default: {
        
        [strongSelf didFailSearchingBeacons];
        
      } break;

    }
    
  }];
  
}

- (void)startRangingBeacons {
  
  if (_beaconRangingManager.ranging) {
    return;
  }
  
  if (!_beaconRangingManager.isRangingAvaliable) {
    [self didFailSearchingBeacons];
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
    [strongSelf didFailSearchingBeacons];
    
  }];
  
}

- (void)didRangeBeacons:(NSArray *)beacons {
  
  [_foundBeacons updateWithBeacons:beacons];
  if (_foundBeacons.readyForProcessing) {
    
    [self processFoundBeacons:_foundBeacons.allBeacons];
    
  }
  
}

- (void)stop {
  
  [_nearestBeaconsRangingTimer invalidate], _nearestBeaconsRangingTimer = nil;
  [_beaconRangingManager stop];

}

@end
