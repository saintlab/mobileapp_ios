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
#import "OMNBeaconsManager.h"

@implementation OMNBeaconSearchManager {
  OMNBeaconsManager *_beaconManager;

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

  [_beaconManager stopMonitoring];
  _beaconManager = nil;
  
}

- (void)startSearchingBeacon {
  
  [self checkNetworkState];
  
}

- (void)checkNetworkState {
  
  __weak typeof(self)weakSelf = self;
  [[OMNOperationManager sharedManager] getReachableState:^(BOOL isReachable) {
    
    
    if (isReachable) {

      [weakSelf checkBluetoothState];
      
    }
    else {
      [weakSelf serverUnavaliableState];
    }
    
  }];
  
}

- (void)serverUnavaliableState {
  
  [self.delegate beaconSearchManagerServerUnavaliableState:self];
  
}

- (void)requestLocationManagerPermission {

  [self.delegate beaconSearchManagerDidRequestLocationManagerPermission:self];
  
}

- (void)checkBluetoothState {
  
  __weak typeof(self)weakSelf = self;
  
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {
    
    switch (state) {
      case CBCentralManagerStatePoweredOn: {
        
        [weakSelf startSearchingBeacons];
        
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
  
  [_beaconManager stopMonitoring];
  [self.delegate beaconSearchManagerDidRequestTurnBLEOn:self];
  
}

- (void)processBLEUnauthorizedSituation {
  //do nothing at this moment
  NSLog(@"processBLEUnauthorizedSituation");
}

- (void)startSearchingBeacons {
  
  if (TARGET_OS_IPHONE &&
      kCLAuthorizationStatusNotDetermined == [CLLocationManager authorizationStatus]) {
    [self requestLocationManagerPermission];
    return;
  }
  
  if (nil == _beaconManager) {
    _beaconManager = [[OMNBeaconsManager alloc] init];
  }
  
  if (_beaconManager.ragingMonitorEnabled) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [_beaconManager startMonitoringNearestBeacons:^(NSArray *foundBeacons) {
    
    [weakSelf checkNearestBeacons:foundBeacons];
    
  } status:^(CLAuthorizationStatus status) {
    
    [weakSelf processCoreLocationAuthorizationStatus:status];
    
  }];
  
}

- (void)checkNearestBeacons:(NSArray *)nearestBeacons {
  
  if (0 == nearestBeacons.count) {
    return;
  }
  NSLog(@"nearestBeacons>%@", nearestBeacons);
  
  [_beaconManager stopMonitoring];
  
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
      
    } break;
    case kCLAuthorizationStatusDenied: {
      
      [self.delegate beaconSearchManagerDidRequestCoreLocationDeniedPermission:self];
      
    } break;
    case kCLAuthorizationStatusNotDetermined: {
      
    } break;
    case kCLAuthorizationStatusRestricted: {
      
      [self.delegate beaconSearchManagerDidRequestCoreLocationRestrictedPermission:self];
      
    } break;
      
  }
  
}

@end
