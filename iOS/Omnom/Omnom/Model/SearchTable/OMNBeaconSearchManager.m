//
//  OMNSearchTableManager.m
//  omnom
//
//  Created by tea on 18.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconSearchManager.h"
#import "OMNOperationManager.h"
#import "OMNBluetoothManager.h"
#import "OMNDecodeBeaconManager.h"
#import "OMNNearestBeaconsManager.h"

@implementation OMNBeaconSearchManager {
  OMNNearestBeaconsManager *_nearestBeaconsManager;

}

- (void)dealloc {
  [self stop];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (void)stop {

  [_nearestBeaconsManager stop];
  _nearestBeaconsManager = nil;
  
}

- (void)startSearching {
  
  [self checkNetworkState];
  
}

- (void)checkNetworkState {
  
  __weak typeof(self)weakSelf = self;
  [[OMNOperationManager sharedManager] getReachableState:^(OMNReachableState reachableState) {
    
    switch (reachableState) {
      case kOMNReachableStateIsReachable: {

        [weakSelf checkBluetoothState];
        
      } break;
      case kOMNReachableStateNoOmnom: {
        
        [weakSelf omnomUnavaliableState];
        
      } break;
      case kOMNReachableStateNoInternet: {
      
        [weakSelf internetUnavaliableState];
        
      } break;
    }
    
  }];
  
}

- (void)omnomUnavaliableState {
  
  [self.delegate beaconSearchManagerOmnomUnavaliableState:self];
  
}

- (void)internetUnavaliableState {
  
  [self.delegate beaconSearchManagerInternetUnavaliableState:self];
  
}

- (void)checkBluetoothState {
  
  __weak typeof(self)weakSelf = self;
  
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {
    
    switch (state) {
      case CBCentralManagerStatePoweredOn: {
        
        [weakSelf.delegate beaconSearchManagerBLEDidOn:weakSelf];
        [weakSelf startRangeNearestBeacons];
        
      } break;
      case CBCentralManagerStateUnsupported: {
        
        [weakSelf BLEUnsupported];
        [[OMNBluetoothManager manager] stop];
        
      } break;
      case CBCentralManagerStatePoweredOff: {
        
        [weakSelf processBLEOffSituation];
        
      } break;
      case CBCentralManagerStateUnauthorized: {
        
        [weakSelf processBLEUnauthorizedSituation];
        
      } break;
      case CBCentralManagerStateResetting:
      case CBCentralManagerStateUnknown: {
        //do noithing
      } break;
    }
    
  }];
  
}

- (void)BLEUnsupported {
  
  [self.delegate beaconSearchManagerBLEUnsupported:self];
  
}

- (void)processBLEOffSituation {
  
  [_nearestBeaconsManager stop];
  [self.delegate beaconSearchManagerDidRequestTurnBLEOn:self];
  
}

- (void)processBLEUnauthorizedSituation {
  //do nothing at this moment
  NSLog(@"processBLEUnauthorizedSituation");
}

- (void)startRangeNearestBeacons {
  
  if (TARGET_OS_IPHONE &&
      kCLAuthorizationStatusNotDetermined == [CLLocationManager authorizationStatus]) {
    
    [self.delegate beaconSearchManagerDidRequestLocationManagerPermission:self];
    
    return;
  }
  
  
  if (nil == _nearestBeaconsManager) {
    __weak typeof(self)weakSelf = self;
    _nearestBeaconsManager = [[OMNNearestBeaconsManager alloc] initWithStatusBlock:^(CLAuthorizationStatus status) {
      [weakSelf processCoreLocationAuthorizationStatus:status];
    }];
  }
  
  if (_nearestBeaconsManager.isRanging) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [_nearestBeaconsManager rangeNearestBeacons:^(NSArray *foundBeacons) {
    
    [weakSelf checkNearestBeacons:foundBeacons];
    
  }];
  
  [self.delegate beaconSearchManagerDidStartSearching:self];
  
}

- (void)checkNearestBeacons:(NSArray *)nearestBeacons {
  
  if (0 == nearestBeacons.count) {
    return;
  }
  NSLog(@"nearestBeacons>%@", nearestBeacons);
  
  [_nearestBeaconsManager stop];
  
  if (nearestBeacons.count > 1) {
    
    [self determineDeviceFaceUpPosition];
    
  }
  else {
    
    OMNBeacon *beacon = [nearestBeacons firstObject];
    [self.delegate beaconSearchManager:self didFindBeacon:beacon];
    
  }
  
}

- (void)determineDeviceFaceUpPosition {
  
  [self.delegate beaconSearchManagerDidRequestDeviceFaceUpPosition:self];
  
}

- (void)processCoreLocationAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
    case kCLAuthorizationStatusAuthorized: {
      
      [self startRangeNearestBeacons];
      
    } break;
    case kCLAuthorizationStatusDenied: {
      
      [_nearestBeaconsManager stop];
      [self.delegate beaconSearchManagerDidRequestCoreLocationDeniedPermission:self];
      
    } break;
    case kCLAuthorizationStatusNotDetermined: {
      
    } break;
    case kCLAuthorizationStatusRestricted: {
      
      [_nearestBeaconsManager stop];
      [self.delegate beaconSearchManagerDidRequestCoreLocationRestrictedPermission:self];
      
    } break;
      
  }
  
}

@end
