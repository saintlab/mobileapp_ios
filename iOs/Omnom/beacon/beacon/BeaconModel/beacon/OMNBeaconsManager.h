//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

extern NSString * const OMNBeaconsManagerDidChangeBeaconsNotification;

typedef  NS_ENUM(NSInteger, BeaconsManagerStatus) {
  kBeaconsManagerStatusNotDetermined = 0,
  kBeaconsManagerStatusEnabled,
  kBeaconsManagerStatusDenied,
  kBeaconsManagerStatusRestricted,
  
  kBeaconsManagerStatusBluetoothOff,
  kBeaconsManagerStatusBluetoothUnsupported,
  kBeaconsManagerStatusBluetoothUnauthorized,
};

typedef void(^OMNFoundBeaconsBlock)(NSArray *foundBeacons);
typedef void(^OMNBeaconsManagerStatusBlock)(BeaconsManagerStatus status);

@interface OMNBeaconsManager : NSObject 

- (void)startMonitoringNearestBeacons:(OMNFoundBeaconsBlock)block status:(OMNBeaconsManagerStatusBlock)statusBlock;

- (void)stopMonitoring;

@end
