//
//  GBeaconBackgroundManager.h
//  beacon
//
//  Created by tea on 03.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNBeacon;

/**
 This class is responible to handle background beacon finding, 
 */

typedef void(^OMNBeaconBackgroundManagerDidFindBlock)(OMNBeacon *foundBeacon, dispatch_block_t comlitionBlock);

@interface OMNBeaconBackgroundManager : NSObject

@property (nonatomic, assign, readonly) BOOL lookingForNearestBeacon;

@property (nonatomic, copy) OMNBeaconBackgroundManagerDidFindBlock didFindBeaconBlock;

+ (instancetype)manager;

- (void)startBeaconRegionMonitoring;

- (void)forgetFoundBeacons;

- (void)handlePush:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end

