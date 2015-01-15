//
//  OMNBeaconRangingManager.h
//  beacon
//
//  Created by tea on 18.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void(^CLBeaconsBlock)(NSArray *beacons);
typedef void(^CLAuthorizationStatusBlock)(CLAuthorizationStatus status);

extern NSTimeInterval const kBeaconSearchTimeout;

@interface OMNBeaconRangingManager : NSObject

@property (nonatomic, assign, readonly) BOOL ranging;
@property (nonatomic, copy, readonly) CLAuthorizationStatusBlock statusBlock;
@property (nonatomic, assign, readonly) CLAuthorizationStatus authorizationStatus;

- (instancetype)initWithStatusBlock:(CLAuthorizationStatusBlock)statusBlock;

/**
 Start searching nearest beacons
 @param didRangeNearestBeaconsBlock completition block, fires anytime when manager find beacons in range. Should be started on main thread
 @param failureBlock failure block, run -(void)stop method when this block fires.
 */
- (void)rangeBeacons:(CLBeaconsBlock)didRangeBeaconsBlock failure:(void (^)(NSError *error))failureBlock;

/**
 Stop ranging
 */
- (void)stop;

@end
