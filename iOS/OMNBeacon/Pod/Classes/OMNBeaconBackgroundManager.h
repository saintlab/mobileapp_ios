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

typedef void(^OMNBeaconsBackgroundManagerDidFindBlock)(NSArray *foundBeacons, dispatch_block_t comletionBlock);

@interface OMNBeaconBackgroundManager : NSObject

@property (nonatomic, assign, readonly) BOOL lookingForNearestBeacon;

@property (nonatomic, copy) OMNBeaconsBackgroundManagerDidFindBlock didFindBeaconsBlock;

+ (instancetype)manager;

- (void)handlePush:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end

