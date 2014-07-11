//
//  OMNBeaconSessionInfo.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeacon.h"

@interface OMNBeaconSessionInfo : NSObject

@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, assign) CLProximity proximity;
@property (nonatomic, assign) NSInteger rssi;

- (instancetype)initWithBeacon:(OMNBeacon *)beacon;

@end
