//
//  OMNBeaconRangingManager.h
//  beacon
//
//  Created by tea on 18.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "OMNConstants.h"

typedef void(^CLBeaconsBlock)(NSArray *beacons);
typedef void(^CLAuthorizationStatusBlock)(CLAuthorizationStatus status);

@interface OMNBeaconRangingManager : NSObject

- (instancetype)initWithAuthorizationStatus:(CLAuthorizationStatusBlock)authorizationStatusBlock;

/**
 Start searching nearest beacons
 @param didRangeNearestBeaconsBlock completition block, fires anytime when manager find beacons in range. Should be started on main thread
 @param failureBlock failure block, run -(void)stop method when this block fires.
 */
- (void)rangeNearestBeacons:(CLBeaconsBlock)didRangeNearestBeaconsBlock failure:(OMNErrorBlock)failureBlock;

/**
 Stop ranging
 */
- (void)stop;

@end
