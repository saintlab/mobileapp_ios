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
  kSearchManagerOmnomServerUnavaliable = 0,
  kSearchManagerInternetUnavaliable,
  kSearchManagerStartSearchingBeacons,
  kSearchManagerNotFoundBeacons,
  
  kSearchManagerRequestLocationManagerPermission,
  kSearchManagerRequestCoreLocationDeniedPermission,
  kSearchManagerRequestCoreLocationRestrictedPermission,
  
  kSearchManagerBLEDidOn,
  kSearchManagerBLEUnsupported,
  kSearchManagerRequestTurnBLEOn,
  kSearchManagerRequestDeviceFaceUpPosition,
  
};

@interface OMNBeaconSearchManager : NSObject

@property (nonatomic, weak) id<OMNBeaconSearchManagerDelegate> delegate;

- (void)startSearching;
- (void)stop;

@end

@protocol OMNBeaconSearchManagerDelegate <NSObject>

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didFindBeacon:(OMNBeacon *)beacon;

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didChangeState:(OMNSearchManagerState)state;


@end