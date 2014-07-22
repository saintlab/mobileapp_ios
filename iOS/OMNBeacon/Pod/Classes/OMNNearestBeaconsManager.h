//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconRangingManager.h"

typedef void(^OMNFoundBeaconsBlock)(NSArray *foundBeacons);

@interface OMNNearestBeaconsManager : NSObject 

@property (nonatomic, assign, readonly) BOOL isRanging;

- (instancetype)initWithStatusBlock:(CLAuthorizationStatusBlock)statusBlock;

- (void)rangeNearestBeacons:(OMNFoundBeaconsBlock)block;

- (void)stop;

@end
