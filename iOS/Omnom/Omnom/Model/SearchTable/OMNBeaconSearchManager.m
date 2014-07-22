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

NSTimeInterval kBeaconSearchTimeout = 2.0;

@implementation OMNBeaconSearchManager {
  OMNNearestBeaconsManager *_nearestBeaconsManager;
  NSTimer *_nearestBeaconsRangingTimer;
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

- (void)stopRangingTimer {
  [_nearestBeaconsRangingTimer invalidate];
  _nearestBeaconsRangingTimer = nil;
}

- (void)stopRangingNearestBeacons {
  [self stopRangingTimer];
  [_nearestBeaconsManager stop];
}

- (void)beaconSearchTimeout {
  
  [self stopRangingNearestBeacons];
  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerNotFoundBeacons];
  
}

- (void)stop {

  [self stopRangingNearestBeacons];
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
  
  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerOmnomServerUnavaliable];
  
}

- (void)internetUnavaliableState {
  
  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerInternetUnavaliable];
  
}

- (void)checkBluetoothState {
  
  __weak typeof(self)weakSelf = self;
  
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {
    
    switch (state) {
      case CBCentralManagerStatePoweredOn: {
        
        [weakSelf.delegate beaconSearchManager:weakSelf didChangeState:kSearchManagerBLEDidOn];
        [weakSelf startRangeNearestBeacons];
        
      } break;
      case CBCentralManagerStateUnsupported: {
        
        [weakSelf.delegate beaconSearchManager:weakSelf didChangeState:kSearchManagerBLEUnsupported];
        //no need monitoring anymore
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

- (void)processBLEOffSituation {
  
  [self stopRangingNearestBeacons];
  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerRequestTurnBLEOn];
  
}

- (void)processBLEUnauthorizedSituation {
  //do nothing at this moment
  NSLog(@"processBLEUnauthorizedSituation");
}

- (void)startRangeNearestBeacons {
  
  if (nil == _nearestBeaconsManager) {
    __weak typeof(self)weakSelf = self;
    _nearestBeaconsManager = [[OMNNearestBeaconsManager alloc] initWithStatusBlock:^(CLAuthorizationStatus status) {
      [weakSelf processCoreLocationAuthorizationStatus:status];
    }];
  }
  
  if (TARGET_OS_IPHONE &&
      kCLAuthorizationStatusNotDetermined == [CLLocationManager authorizationStatus]) {
    
    [self.delegate beaconSearchManager:self didChangeState:kSearchManagerRequestLocationManagerPermission];
    
    return;
  }
  
  if (_nearestBeaconsManager.isRanging) {
    return;
  }

  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerStartSearchingBeacons];

  _nearestBeaconsRangingTimer = [NSTimer scheduledTimerWithTimeInterval:kBeaconSearchTimeout target:self selector:@selector(beaconSearchTimeout) userInfo:nil repeats:NO];
  
  __weak typeof(self)weakSelf = self;
  [_nearestBeaconsManager rangeNearestBeacons:^(NSArray *foundBeacons) {
    
    [weakSelf checkNearestBeacons:foundBeacons];
    
  }];
  
}

- (void)checkNearestBeacons:(NSArray *)nearestBeacons {
  
  if (0 == nearestBeacons.count) {
    return;
  }
  [self stopRangingNearestBeacons];
  
  if (nearestBeacons.count > 1) {
    
    [self.delegate beaconSearchManager:self didChangeState:kSearchManagerRequestDeviceFaceUpPosition];
    
  }
  else {
    
    OMNBeacon *beacon = [nearestBeacons firstObject];
    [self.delegate beaconSearchManager:self didFindBeacon:beacon];
    
  }
  
}

- (void)processCoreLocationAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
    case kCLAuthorizationStatusAuthorized: {
      
      [self startRangeNearestBeacons];
      
    } break;
    case kCLAuthorizationStatusDenied: {
      
      [self stopRangingNearestBeacons];
      [self.delegate beaconSearchManager:self didChangeState:kSearchManagerRequestCoreLocationDeniedPermission];
      
    } break;
    case kCLAuthorizationStatusNotDetermined: {
      
    } break;
    case kCLAuthorizationStatusRestricted: {
      
      [self stopRangingNearestBeacons];
      [self.delegate beaconSearchManager:self didChangeState:kSearchManagerRequestCoreLocationRestrictedPermission];
      
    } break;
      
  }
  
}


@end
