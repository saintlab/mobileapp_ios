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
  kSearchManagerInternetFound = 0,
  kSearchManagerOmnomServerUnavaliable,
  kSearchManagerInternetUnavaliable,
  kSearchManagerStartSearchingBeacons,
  
  kSearchManagerNotFoundBeacons,
  kSearchManagerRequestReload,
  
  kSearchManagerRequestLocationManagerPermission,
  kSearchManagerRequestCoreLocationDeniedPermission,
  kSearchManagerRequestCoreLocationRestrictedPermission,
  
  kSearchManagerBLEDidOn,
  kSearchManagerBLEUnsupported,
  kSearchManagerRequestTurnBLEOn,
  
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


@end