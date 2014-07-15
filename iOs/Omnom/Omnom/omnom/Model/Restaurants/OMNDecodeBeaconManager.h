//
//  OMNDecodeBeaconManager.h
//  restaurants
//
//  Created by tea on 10.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"

@interface OMNDecodeBeaconManager : NSObject

+ (instancetype)manager;
/**
 Decode list of OMNBeacon objects and get related restaurant and table info
 @param beacons list of OMNDecodeBeacon objects
 @param success success callback, contains list of OMNDecodeBeacon objects
 @param failure error callback, contains NSError object
 */
- (void)decodeBeacons:(NSArray *)beacons success:(OMNBeaconsBlock)success failure:(OMNErrorBlock)failure;

- (void)handleBackgroundBeacon:(OMNBeacon *)beacon complition:(dispatch_block_t)complition;

@end
