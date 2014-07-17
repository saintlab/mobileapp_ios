//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void(^OMNFoundBeaconsBlock)(NSArray *foundBeacons);
typedef void(^OMNBeaconsManagerStatusBlock)(CLAuthorizationStatus status);

@interface OMNBeaconsManager : NSObject 

@property (nonatomic, assign, readonly) BOOL ragingMonitorEnabled;

- (void)startMonitoringNearestBeacons:(OMNFoundBeaconsBlock)block status:(OMNBeaconsManagerStatusBlock)statusBlock;

- (void)stopMonitoring;

@end
