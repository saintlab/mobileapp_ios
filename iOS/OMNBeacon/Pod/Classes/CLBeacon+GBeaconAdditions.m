//
//  CLBeacon+GBeaconAdditions.m
//  beacon
//
//  Created by tea on 06.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "CLBeacon+GBeaconAdditions.h"

@implementation CLBeacon (OMNBeaconAdditions)

- (OMNBeacon *)omn_beacon {
  
  OMNBeacon *beacon = [[OMNBeacon alloc] init];
  beacon.UUIDString = self.proximityUUID.UUIDString;
  beacon.major = [self.major description];
  beacon.minor = [self.minor description];
  [beacon updateWithBeacon:self];
  
  return beacon;
  
}


@end
