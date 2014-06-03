//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

extern NSString * const OMNBeaconsManagerDidChangeBeaconsNotification;

@class OMNBeacon;
@class OMNBeaconsManager;

//typedef void(^OMNBeaconsManagerBlock)(OMNBeaconsManager *beaconsManager);
typedef void(^OMNFoundBeaconsBlock)(NSArray *foundBeacons);

@interface OMNBeaconsManager : NSObject 

- (void)startMonitoring:(OMNFoundBeaconsBlock)block;

- (void)stopMonitoring;

@end
