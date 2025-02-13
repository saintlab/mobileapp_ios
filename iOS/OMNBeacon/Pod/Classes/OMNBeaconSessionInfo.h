//
//  OMNBeaconSessionInfo.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface OMNBeaconSessionInfo : NSObject

@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, assign) CLProximity proximity;
@property (nonatomic, assign) NSInteger rssi;

- (instancetype)initWithBeacon:(CLBeacon *)beacon;
+ (instancetype)infoWithRSSI:(NSInteger)RSSI timeStamp:(NSDate *)timeStamp;

- (NSDictionary *)JSONObject;
- (NSString *)timeStampString;

@end
