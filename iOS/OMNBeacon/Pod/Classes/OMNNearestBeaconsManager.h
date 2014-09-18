//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconRangingManager.h"

@interface OMNNearestBeaconsManager : NSObject 

@property (nonatomic, assign, readonly) BOOL isRanging;

- (instancetype)initWithStatusBlock:(CLAuthorizationStatusBlock)statusBlock;

- (void)rangeNearestBeacons:(void (^)(NSArray *foundBeacons))block;

- (void)stop;

@end
