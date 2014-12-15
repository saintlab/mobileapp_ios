//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconRangingManager.h"
#import "OMNFoundBeacons.h"

typedef void(^OMNNearestBeaconsBlock)(OMNFoundBeacons *foundBeacons);

@interface OMNNearestBeaconsManager : NSObject 

@property (nonatomic, strong, readonly) OMNFoundBeacons *foundBeacons;
@property (nonatomic, strong, readonly) NSDate *startDate;
@property (nonatomic, assign, readonly) BOOL isRanging;

- (instancetype)init __attribute__((unavailable("init not available")));
- (instancetype)initWithStatusBlock:(CLAuthorizationStatusBlock)authorizationStatusBlock;

- (void)findNearestBeacons:(OMNNearestBeaconsBlock)didFindNearestBeaconsBlock failure:(void (^)(NSError *error))failureBlock;
- (void)stopRanging;

@end
