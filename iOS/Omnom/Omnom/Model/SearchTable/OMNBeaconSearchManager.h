//
//  OMNSearchTableManager.h
//  omnom
//
//  Created by tea on 18.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNBeaconSearchManagerDelegate;
@class OMNBeacon;

typedef NS_ENUM(NSInteger, OMNSearchManagerState) {

  kSearchManagerStartSearchingBeacons = 0,
  kSearchManagerNotFoundBeacons,
  kSearchManagerRequestReload,
  
};

typedef NS_ENUM(NSInteger, OMNBLESearchManagerState) {
  
  kBLESearchManagerBLEDidOn = 0,
  kBLESearchManagerBLEUnsupported,
  kBLESearchManagerRequestTurnBLEOn,
  
};

typedef NS_ENUM(NSInteger, OMNCLSearchManagerState) {
  
  kCLSearchManagerRequestPermission,
  kCLSearchManagerRequestDeniedPermission,
  kCLSearchManagerRequestRestrictedPermission,
  
};

@interface OMNBeaconSearchManager : NSObject

@property (nonatomic, weak) id<OMNBeaconSearchManagerDelegate> delegate;

- (void)startSearching;
- (void)stop:(BOOL)didFind;

@end

@protocol OMNBeaconSearchManagerDelegate <NSObject>

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didFindAtTheTableBeacons:(NSArray *)atTheTableBeacons allBeacons:(NSArray *)allBeacons;
- (void)beaconSearchManagerDidStop:(OMNBeaconSearchManager *)beaconSearchManager found:(BOOL)foundBeacon;

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didChangeState:(OMNSearchManagerState)state;

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didDetermineBLEState:(OMNBLESearchManagerState)bleState;
- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didDetermineCLState:(OMNCLSearchManagerState)clState;

@end