//
//  GBeacon.h
//  beacon
//
//  Created by tea on 21.02.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "OMNBeaconUUID.h"

extern const NSInteger kBoardingRSSI;

typedef NS_ENUM(NSInteger, BeaconDistance) {
  kBeaconDistanceNear,
  kBeaconDistanceFar,
};

extern NSTimeInterval const kTimeToDeleteMarkSec;

@interface OMNBeacon : NSObject

@property (nonatomic, copy) NSString *UUIDString;
@property (nonatomic, copy) NSString *major;
@property (nonatomic, copy) NSString *minor;
@property (nonatomic, assign) CLProximity proximity;
@property (nonatomic, assign) CLLocationAccuracy accuracy;
@property (nonatomic, assign) NSInteger rssi;

@property (nonatomic, assign) BeaconDistance beaconDistance;

@property (nonatomic, assign, readonly) BOOL atTheTable;

@property (nonatomic, assign, readonly) BOOL nearTheTable;


+ (void)setBaeconUUID:(OMNBeaconUUID *)beaconUUID;
+ (OMNBeaconUUID *)beaconUUID;

- (instancetype)initWithJsonData:(id)jsonData;

- (NSTimeInterval)atTheTableTime;

- (BOOL)closeToBeacon:(OMNBeacon *)beacon;

- (void)updateWithBeacon:(CLBeacon *)beacon;

- (void)removeFromTable;

- (double)averageRSSI;

- (void)newIterationBegin;

- (NSString *)key;

- (NSDictionary *)JSONObject;

+ (OMNBeacon *)demoBeacon;

@end

