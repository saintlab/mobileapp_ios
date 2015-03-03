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

@interface OMNBeaconsSearchManager ()

@property (nonatomic, assign) CBCentralManagerState previousBluetoothState;

@end

@implementation OMNBeaconsSearchManager {
  
  dispatch_semaphore_t _addBeaconLock;
  OMNBeaconRangingManager *_beaconRangingManager;
  NSTimer *_nearestBeaconsRangingTimer;
  
}

- (void)dealloc {

  [self stop];
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _addBeaconLock = dispatch_semaphore_create(1);

  }
  return self;
}


- (void)startSearching {
  
  [self stopRangingNearestBeaconsWithError:NO];
  _startDate = [NSDate date];
  
  if (TARGET_IPHONE_SIMULATOR) {
    
    NSArray *beacons = @[[OMNBeacon demoBeacon]];
    [self processFoundBeacons:beacons];
    
  }
  else {
    
    [self checkBluetoothState];
    
  }
  
}

- (void)didRangeBeacons:(NSArray *)beacons {
  
  [_foundBeacons updateWithBeacons:beacons];
  if (_foundBeacons.readyForProcessing) {
    
    [self processFoundBeacons:_foundBeacons.allBeacons];
    
  }
  
  
}

- (void)processFoundBeacons:(NSArray *)beacons {
  
  [self stop];
  [self.delegate beaconSearchManager:self didFindBeacons:beacons];
  
}

- (void)checkBluetoothState {
  
  __weak typeof(self)weakSelf = self;
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {
    
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    switch (state) {
      case CBCentralManagerStatePoweredOn: {
        
        if (CBCentralManagerStatePoweredOff == strongSelf.previousBluetoothState) {
          
          [strongSelf.delegate beaconSearchManager:strongSelf didChangeState:kSearchManagerRequestReload];
          
        }
        else {
          
          [strongSelf.delegate beaconSearchManager:strongSelf didDetermineBLEState:kBLESearchManagerBLEDidOn];
          [strongSelf startRangingBeacons];
          
        }
        
      } break;
      case CBCentralManagerStateUnsupported: {
        
        [strongSelf startRangingBeacons];
        
      } break;
      case CBCentralManagerStatePoweredOff: {
        
        [strongSelf stopRangingNearestBeaconsWithError:NO];
        [strongSelf.delegate beaconSearchManager:strongSelf didDetermineBLEState:kBLESearchManagerRequestTurnBLEOn];
        
      } break;
      case CBCentralManagerStateUnauthorized: {
        
        //do noithing
        
      } break;
      case CBCentralManagerStateResetting:
      case CBCentralManagerStateUnknown: {
        //do noithing
      } break;
    }
    
    strongSelf.previousBluetoothState = state;
    if (state != CBCentralManagerStatePoweredOn) {
      
      [strongSelf.delegate beaconSearchManagerDidFail:strongSelf];
      
    }
    
  }];
  
}

- (void)startRangingBeacons {
  
  if (!_beaconRangingManager) {
    __weak typeof(self)weakSelf = self;
    _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithStatusBlock:^(CLAuthorizationStatus status) {
      
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf processCoreLocationAuthorizationStatus:status];
      
    }];
  }
  
  CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
  
  if (TARGET_OS_IPHONE &&
      kCLAuthorizationStatusNotDetermined == authorizationStatus) {
    
    [self.delegate beaconSearchManagerDidFail:self];
    [self.delegate beaconSearchManager:self didDetermineCLState:kCLSearchManagerRequestPermission];
    
    return;
  }
  
  if (_beaconRangingManager.ranging) {
    return;
  }
  
  if (kCLAuthorizationStatusAuthorizedAlways != authorizationStatus) {
    
    [self processCoreLocationAuthorizationStatus:authorizationStatus];
    return;
    
  }
  
  if (!_beaconRangingManager.isRangingAvaliable) {
    [self.delegate beaconSearchManager:self didDetermineBLEState:kBLESearchManagerBLEUnsupported];
    return;
  }
  
  _foundBeacons = [[OMNFoundBeacons alloc] init];
  _nearestBeaconsRangingTimer = [NSTimer scheduledTimerWithTimeInterval:kBeaconSearchTimeout target:self selector:@selector(beaconSearchTimeout) userInfo:nil repeats:NO];
  
  __weak typeof(self)weakSelf = self;
  [_beaconRangingManager rangeBeacons:^(NSArray *beacons) {
    
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf didRangeBeacons:beacons];
    
  } failure:^(NSError *error) {
    
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf beaconsSearchDidFailWithError:error];
    
  }];

  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerStartSearchingBeacons];
  
}

- (void)beaconsSearchDidFailWithError:(NSError *)error {
  
  NSMutableDictionary *debugData = [NSMutableDictionary dictionary];
  if (error.localizedDescription) {
    
    debugData[@"error"] = error.localizedDescription;
    debugData[@"code"] = @(error.code);
    
  }
//  [[OMNAnalitics analitics] logTargetEvent:@"ble_did_stuck" parametrs:debugData];
  [self stopRangingNearestBeaconsWithError:YES];
  [self.delegate beaconSearchManager:self didChangeState:kSearchManagerNotFoundBeacons];
  
}

- (void)processCoreLocationAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
    case kCLAuthorizationStatusDenied: {
      
      [self processCoreLocationDenySituation:kCLSearchManagerRequestDeniedPermission];
      
    } break;
    case kCLAuthorizationStatusRestricted: {
      
      [self processCoreLocationDenySituation:kCLSearchManagerRequestRestrictedPermission];
      
    } break;
    case kCLAuthorizationStatusAuthorizedAlways: {
      
      [self.delegate beaconSearchManager:self didChangeState:kSearchManagerRequestReload];
      
    } break;
    default: {
      //do nothing
    } break;
  }
  
}

- (void)processCoreLocationDenySituation:(OMNCLSearchManagerState)state {
  
  [self stopRangingNearestBeaconsWithError:YES];
  [self.delegate beaconSearchManager:self didDetermineCLState:state];
  
}

- (void)stopRangingNearestBeaconsWithError:(BOOL)error {
  
  [_nearestBeaconsRangingTimer invalidate], _nearestBeaconsRangingTimer = nil;
  [_beaconRangingManager stop];
  if (error) {
    
    [self.delegate beaconSearchManagerDidFail:self];
    
  }
  
}

- (void)stop {
  
  [self stopRangingNearestBeaconsWithError:NO];
  _beaconRangingManager = nil;
  
}

- (void)beaconSearchTimeout {

  [self beaconsSearchDidFailWithError:nil];

}

@end
