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
#import "OMNVisitorManager.h"
#import "OMNNearestBeaconsManager.h"
#import <OMNBeaconBackgroundManager.h>
#import "OMNBeacon+omn_debug.h"
#import "OMNAnalitics.h"

NSTimeInterval kBeaconSearchTimeout = 7.0;

@interface OMNBeaconSearchManager ()

@property (nonatomic, assign) CBCentralManagerState previousBluetoothState;

@end

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
    [_nearestBeaconsManager stopRanging];
    
  }
  
}

- (void)stop:(BOOL)didFind {
  
  [self stopRangingNearestBeacons:didFind];
  _nearestBeaconsManager = nil;
  
}

- (void)startSearching {
  
  if (TARGET_IPHONE_SIMULATOR) {
    
    NSArray *beacons = @[[OMNBeacon demoBeacon]];
    [self processAtTheTableBeacons:beacons allBeacons:beacons];
    
  }
  else {
    
    [self checkBluetoothState];
    
  }

}

- (void)checkBluetoothState {

  __weak typeof(self)weakSelf = self;
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {
    
    switch (state) {
      case CBCentralManagerStatePoweredOn: {
        
        if (CBCentralManagerStatePoweredOff == weakSelf.previousBluetoothState) {
          
          [weakSelf.delegate beaconSearchManager:weakSelf didChangeState:kSearchManagerRequestReload];
          
        }
        else {
          
          [weakSelf.delegate beaconSearchManager:weakSelf didDetermineBLEState:kBLESearchManagerBLEDidOn];
          [weakSelf startRangeNearestBeacons];
          
        }
        
      } break;
      case CBCentralManagerStateUnsupported: {
        
        [weakSelf.delegate beaconSearchManager:weakSelf didDetermineBLEState:kBLESearchManagerBLEUnsupported];
        
      } break;
      case CBCentralManagerStatePoweredOff: {
        
        [weakSelf stopRangingNearestBeacons:NO];
        [weakSelf.delegate beaconSearchManager:self didDetermineBLEState:kBLESearchManagerRequestTurnBLEOn];
        
      } break;
      case CBCentralManagerStateUnauthorized: {
        
        [weakSelf processBLEUnauthorizedSituation];
        
      } break;
      case CBCentralManagerStateResetting:
      case CBCentralManagerStateUnknown: {
        //do noithing
      } break;
    }
    
    weakSelf.previousBluetoothState = state;
    if (state != CBCentralManagerStatePoweredOn) {
      
      [weakSelf.delegate beaconSearchManagerDidStop:weakSelf found:NO];
      
    }
    
  }];
  
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
  
  CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
  
  if (TARGET_OS_IPHONE &&
      kCLAuthorizationStatusNotDetermined == authorizationStatus) {
    
    [self.delegate beaconSearchManagerDidStop:self found:NO];
    [self.delegate beaconSearchManager:self didDetermineCLState:kCLSearchManagerRequestPermission];
    
    return;
  }
  
  if (_nearestBeaconsManager.isRanging) {
    return;
  }
  
  
  if (kCLAuthorizationStatusAuthorizedAlways != authorizationStatus) {
    
    [self processCoreLocationAuthorizationStatus:authorizationStatus];
    return;
    
  }
  
  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerStartSearchingBeacons];

  _nearestBeaconsRangingTimer = [NSTimer scheduledTimerWithTimeInterval:kBeaconSearchTimeout target:self selector:@selector(beaconSearchTimeout) userInfo:nil repeats:NO];
  
  __weak typeof(self)weakSelf = self;
  [_nearestBeaconsManager findNearestBeacons:^(OMNFoundBeacons *foundBeacons) {

    [weakSelf processAtTheTableBeacons:foundBeacons.atTheTableBeacons allBeacons:foundBeacons.allBeacons];
    
  } failure:^(NSError *error) {
    
    [weakSelf beaconsSearchDidFailWithError:error];
    
  }];
  
}

- (void)beaconsSearchDidFailWithError:(NSError *)error {

  NSMutableDictionary *debugData = [NSMutableDictionary dictionary];
  if (error.localizedDescription) {
    
    debugData[@"error"] = error.localizedDescription;
    debugData[@"code"] = @(error.code);
    
  }
  
  [[OMNAnalitics analitics] logTargetEvent:@"ble_did_stuck" parametrs:debugData];
  [self stopRangingNearestBeacons:NO];
  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerNotFoundBeacons];

}

- (void)beaconSearchTimeout {
  
  NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:_nearestBeaconsManager.startDate];
  OMNFoundBeacons *foundBeacons = _nearestBeaconsManager.foundBeacons;
  NSMutableDictionary *debugData = [[OMNBeacon omn_debugDataFromNearestBeacons:foundBeacons.atTheTableBeacons allBeacons:foundBeacons.allBeacons] mutableCopy];
  debugData[@"duration"] = @(timeInterval);
  [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BEACONS_FOUND_TIMEOUT" parametrs:debugData];
  
  [self stopRangingNearestBeacons:NO];
  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerNotFoundBeacons];
  
}

- (void)processAtTheTableBeacons:(NSArray *)atTheTableBeacons allBeacons:(NSArray *)allBeacons {
  
  BOOL beaconDidFound = (atTheTableBeacons.count == 1);
  [self stopRangingNearestBeacons:beaconDidFound];
  [self.delegate beaconSearchManager:self didFindAtTheTableBeacons:atTheTableBeacons allBeacons:allBeacons];
  
}

- (void)processCoreLocationDenySituation:(OMNCLSearchManagerState)state {
  
  _coreLocationDenied = YES;
  [self stopRangingNearestBeacons:NO];
  [self.delegate beaconSearchManager:self didDetermineCLState:state];
  
}

- (void)processCoreLocationAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
      
    case kCLAuthorizationStatusDenied: {
      
      [self processCoreLocationDenySituation:kCLSearchManagerRequestDeniedPermission];
      
    } break;
    case kCLAuthorizationStatusNotDetermined: {
      
      
    } break;
    case kCLAuthorizationStatusRestricted: {
      
      [self processCoreLocationDenySituation:kCLSearchManagerRequestRestrictedPermission];
      
    } break;
    default: {
      
      if (_coreLocationDenied) {
        
        _coreLocationDenied = NO;
        [self.delegate beaconSearchManager:self didChangeState:kSearchManagerRequestReload];
        
      }
      else {
        
        [[OMNBeaconBackgroundManager manager] startBeaconRegionMonitoring];
        [self.delegate beaconSearchManager:self didChangeState:kSearchManagerRequestReload];
        
      }
      
    } break;
  }
  
}


@end
