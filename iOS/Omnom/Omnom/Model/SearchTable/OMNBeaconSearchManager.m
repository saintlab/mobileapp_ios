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
#import <OMNBeaconBackgroundManager.h>

NSTimeInterval kBeaconSearchTimeout = 2.0;

@implementation OMNBeaconSearchManager {
  OMNNearestBeaconsManager *_nearestBeaconsManager;
  NSTimer *_nearestBeaconsRangingTimer;
  BOOL _coreLocationDenied;
}

- (void)dealloc {
  [self stop:NO];
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

- (void)stopRangingNearestBeacons:(BOOL)beaconFound {
  
  [self stopRangingTimer];
  
  if (_nearestBeaconsManager) {
    [self.delegate beaconSearchManagerDidStop:self found:beaconFound];
    [_nearestBeaconsManager stop];
  }
  
}

- (void)beaconSearchTimeout {
  
  [self stopRangingNearestBeacons:NO];
  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerNotFoundBeacons];
  
}

- (void)stop:(BOOL)didFind {

  [self stopRangingNearestBeacons:didFind];
  _nearestBeaconsManager = nil;
  
}

- (void)startSearching {

#if TARGET_IPHONE_SIMULATOR
#warning useStubBeacon2
  OMNBeacon *beacon = [[OMNBeacon alloc] init];
  beacon.UUIDString = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
  beacon.major = @(1);
  beacon.minor = @(1);
  [self didFindBeacon:beacon];

#else
  [self checkNetworkState];
#endif
  
}

- (void)checkNetworkState {
  
  __weak typeof(self)weakSelf = self;
  [[OMNOperationManager sharedManager] getReachableState:^(OMNReachableState reachableState) {
    
    switch (reachableState) {
      case kOMNReachableStateIsReachable: {

        [weakSelf.delegate beaconSearchManager:weakSelf didChangeState:kSearchManagerInternetFound];
        [weakSelf checkBluetoothState];
        
      } break;
      case kOMNReachableStateNoOmnom: {
        
        [weakSelf.delegate beaconSearchManager:weakSelf didChangeState:kSearchManagerOmnomServerUnavaliable];
        
      } break;
      case kOMNReachableStateNoInternet: {
      
        [weakSelf.delegate beaconSearchManager:weakSelf didChangeState:kSearchManagerInternetUnavaliable];
        
      } break;
    }
    
    if (reachableState != kOMNReachableStateIsReachable) {
      [weakSelf.delegate beaconSearchManagerDidStop:weakSelf found:NO];
    }
    
  }];
  
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
    
    if (state != CBCentralManagerStatePoweredOn) {
      [weakSelf.delegate beaconSearchManagerDidStop:weakSelf found:NO];
    }
    
  }];
  
}

- (void)processBLEOffSituation {
  
  [self stopRangingNearestBeacons:NO];
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
    
    [self.delegate beaconSearchManagerDidStop:self found:NO];
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
  
  
  if (nearestBeacons.count > 1) {
  
    [self stopRangingNearestBeacons:NO];
    [self.delegate beaconSearchManager:self didChangeState:kSearchManagerRequestDeviceFaceUpPosition];
    
  }
  else {
    
    [self didFindBeacon:[nearestBeacons firstObject]];
    
  }
  
}

- (void)didFindBeacon:(OMNBeacon *)beacon {
  
  [self stopRangingNearestBeacons:YES];
  [self.delegate beaconSearchManager:self didFindBeacon:beacon];
  
}

- (void)processCoreLocationDenySituation:(OMNSearchManagerState)state {
  _coreLocationDenied = YES;
  [self stopRangingNearestBeacons:NO];
  [self.delegate beaconSearchManager:self didChangeState:state];
}

- (void)processCoreLocationAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {

    case kCLAuthorizationStatusDenied: {
      
      [self processCoreLocationDenySituation:kSearchManagerRequestCoreLocationDeniedPermission];
      
    } break;
    case kCLAuthorizationStatusNotDetermined: {
      
    } break;
    case kCLAuthorizationStatusRestricted: {
      
      [self processCoreLocationDenySituation:kSearchManagerRequestCoreLocationRestrictedPermission];

    } break;
    default: {
      
      if (_coreLocationDenied) {
        _coreLocationDenied = NO;
        [self.delegate beaconSearchManager:self didChangeState:kSearchManagerRequestReload];
      }
      else {
        
        [[OMNBeaconBackgroundManager manager] startBeaconRegionMonitoring];
        [self startRangeNearestBeacons];
        
      }
      
    } break;
  }
  
}


@end
