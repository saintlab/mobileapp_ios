//
//  OMNDecodeBeaconManager.h
//  restaurants
//
//  Created by tea on 10.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"

extern NSString * const OMNDecodeBeaconManagerNotificationLaunchKey;

@interface OMNDecodeBeaconManager : NSObject

+ (instancetype)manager;
/**
 Decode list of OMNBeacon objects and get related restaurant and table info
 @param beacons list of @{OMNBeacon} objects
 @param success success callback, contains list of OMNDecodeBeacon objects
 @param failure error callback, contains NSError object
 */
- (void)decodeBeacons:(NSArray *)beacons success:(OMNBeaconsBlock)success failure:(void (^)(NSError *error))failure;

- (void)handleBackgroundBeacon:(OMNBeacon *)beacon completion:(dispatch_block_t)completion;

@end
