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

@interface OMNBeaconBackgroundManager : NSObject

@property (nonatomic, assign, readonly) BOOL lookingForNearestBeacon;

+ (instancetype)manager;

- (void)handlePush:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
