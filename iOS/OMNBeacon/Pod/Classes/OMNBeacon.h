//
//  GBeacon.h
//  beacon
//
//  Created by tea on 21.02.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

extern const NSInteger kBoardingRSSI;

typedef NS_ENUM(NSInteger, BeaconDistance) {
  kBeaconDistanceNear,
  kBeaconDistanceFar,
};

extern NSTimeInterval const kTimeToDeleteMarkSec;

@interface OMNBeacon : NSObject

@property (nonatomic, copy) NSString *UUIDString;
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSString *minor;
@property (nonatomic, assign) CLProximity proximity;
@property (nonatomic, assign) CLLocationAccuracy accuracy;
@property (nonatomic, assign) NSInteger rssi;

@property (nonatomic, assign) BeaconDistance beaconDistance;

@property (nonatomic, assign, readonly) BOOL atTheTable;

@property (nonatomic, assign, readonly) BOOL nearTheTable;

- (NSTimeInterval)atTheTableTime;

- (BOOL)closeToBeacon:(OMNBeacon *)beacon;

- (void)updateWithBeacon:(OMNBeacon *)beacon;

- (void)removeFromTable;

- (double)totalRSSI;

/**
 Ttis method is used to notify beacon remove outdated info
 */
- (void)newIterationBegin;

- (NSString *)key;

- (NSDictionary *)JSONObject;

@end

/**
 При обнаружении метки записанной в базу, обновляется поле с временной меткой последнего обнаружения
 */

/**
 При обнаружении метки записанной в базу, обновляется поле с временной меткой последнего обнаружения
 Если с момента последнего обнаружения метки прошло больше N часов, то запись удаляется из хранилища
 
 время первого обнаружения
 время последнего обнаружения
 */
//@property (nonatomic, strong, readonly) NSDate *firstFoundDate;
//@property (nonatomic, strong, readonly) NSDate *previousFoundDate;
//@property (nonatomic, strong, readonly) NSDate *lastFoundDate;

