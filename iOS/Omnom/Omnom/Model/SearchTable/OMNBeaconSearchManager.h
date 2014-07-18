//
//  OMNSearchTableManager.h
//  omnom
//
//  Created by tea on 18.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNBeaconSearchManagerDelegate;
@class OMNBeacon;


@interface OMNBeaconSearchManager : NSObject

@property (nonatomic, weak) id<OMNBeaconSearchManagerDelegate> delegate;

- (void)startSearchingBeacon;
- (void)stop;

@end

@protocol OMNBeaconSearchManagerDelegate <NSObject>

- (void)beaconSearchManager:(OMNBeaconSearchManager *)beaconSearchManager didFindBeacon:(OMNBeacon *)beacon;

- (void)beaconSearchManagerServerUnavaliableState:(OMNBeaconSearchManager *)beaconSearchManager;
- (void)beaconSearchManagerDidRequestLocationManagerPermission:(OMNBeaconSearchManager *)beaconSearchManager;

- (void)beaconSearchManagerBLEUnsupported:(OMNBeaconSearchManager *)beaconSearchManager;
- (void)beaconSearchManagerDidRequestTurnBLEOn:(OMNBeaconSearchManager *)beaconSearchManager;

- (void)beaconSearchManagerDidRequestDeviceFaceUpPosition:(OMNBeaconSearchManager *)beaconSearchManager;

- (void)beaconSearchManagerDidRequestCoreLocationDeniedPermission:(OMNBeaconSearchManager *)beaconSearchManager;
- (void)beaconSearchManagerDidRequestCoreLocationRestrictedPermission:(OMNBeaconSearchManager *)beaconSearchManager;

@end