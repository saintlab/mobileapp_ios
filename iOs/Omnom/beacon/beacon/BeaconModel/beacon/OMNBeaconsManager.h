//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

extern NSString * const OMNBeaconsManagerDidChangeBeaconsNotification;

@class OMNBeacon;
@class OMNBeaconsManager;

typedef void(^OMNBeaconsManagerBlock)(OMNBeaconsManager *beaconsManager);

@interface OMNBeaconsManager : NSObject 

/**
 Array of OMNBeacon objects, contains beacons located immediate to device
 */
@property (nonatomic, strong, readonly) NSMutableArray *atTheTableBeacons;

- (void)startMonitoring:(OMNBeaconsManagerBlock)block;

- (void)stopMonitoring;

@end
