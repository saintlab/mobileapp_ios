//
//  GBeacon.h
//  beacon
//
//  Created by tea on 21.02.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "OMNBeaconUUID.h"

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
@property (nonatomic, assign, readonly) BOOL nearTheTable;
@property (nonatomic, assign, readonly) NSInteger totalRSSI;
@property (nonatomic, strong, readonly) NSMutableArray *beaconSessionInfo;

+ (void)setBaeconUUID:(OMNBeaconUUID *)beaconUUID;
+ (OMNBeaconUUID *)beaconUUID;

- (instancetype)initWithJsonData:(id)jsonData;

- (void)updateWithBeacon:(CLBeacon *)beacon;

- (NSString *)key;

- (NSDictionary *)JSONObject;

+ (OMNBeacon *)demoBeacon;

@end

