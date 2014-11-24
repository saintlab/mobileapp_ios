//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconRangingManager.h"

typedef void(^OMNNearestBeaconsBlock)(NSArray *nearestBeacons, NSArray *foundBeacons);

@interface OMNNearestBeaconsManager : NSObject 

@property (nonatomic, assign, readonly) BOOL isRanging;

- (instancetype)initWithStatusBlock:(CLAuthorizationStatusBlock)statusBlock;

- (void)rangeNearestBeacons:(OMNNearestBeaconsBlock)nearestBeaconsBlock;

- (void)stop;

@end
