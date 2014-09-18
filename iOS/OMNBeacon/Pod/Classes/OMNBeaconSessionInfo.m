//
//  OMNBeaconSessionInfo.m
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconSessionInfo.h"

@implementation OMNBeaconSessionInfo

- (instancetype)initWithBeacon:(CLBeacon *)beacon {
  self = [super init];
  if (self) {
    self.proximity = beacon.proximity;
    self.rssi = beacon.rssi;
    self.timeStamp = [NSDate date];
  }
  return self;
}

@end
