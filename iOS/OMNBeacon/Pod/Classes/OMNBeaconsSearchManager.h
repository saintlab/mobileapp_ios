//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconRangingManager.h"
#import "OMNFoundBeacons.h"

@protocol OMNBeaconsSearchManagerDelegate;

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

@interface OMNBeaconsSearchManager : NSObject

@property (nonatomic, strong, readonly) OMNFoundBeacons *foundBeacons;
@property (nonatomic, strong, readonly) NSDate *startDate;
@property (nonatomic, weak) id<OMNBeaconsSearchManagerDelegate> delegate;

- (void)startSearching;
- (void)stop;

@end

@protocol OMNBeaconsSearchManagerDelegate <NSObject>

- (void)beaconSearchManager:(OMNBeaconsSearchManager *)beaconsSearchManager didFindBeacons:(NSArray *)beacons;
- (void)beaconSearchManagerDidFail:(OMNBeaconsSearchManager *)beaconsSearchManager;

- (void)beaconSearchManager:(OMNBeaconsSearchManager *)beaconsSearchManager didChangeState:(OMNSearchManagerState)state;

- (void)beaconSearchManager:(OMNBeaconsSearchManager *)beaconsSearchManager didDetermineBLEState:(OMNBLESearchManagerState)bleState;
- (void)beaconSearchManager:(OMNBeaconsSearchManager *)beaconsSearchManager didDetermineCLState:(OMNCLSearchManagerState)clState;

@end