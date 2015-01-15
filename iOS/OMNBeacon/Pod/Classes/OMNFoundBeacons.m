//
//  OMNFoundBeacons.m
//  beacon
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNFoundBeacons.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNBeacon.h"
#import "CLBeacon+GBeaconAdditions.h"

@implementation OMNFoundBeacons {
  
  NSMutableDictionary *_existingBeaconsDictionary;
  
}

@dynamic readyForProcessing;

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _existingBeaconsDictionary = [NSMutableDictionary dictionary];
    
  }
  return self;
}

- (void)updateWithBeacons:(NSArray *)foundBeacons {
 
  NSMutableDictionary *existingBeaconsDictionary = _existingBeaconsDictionary;

  [foundBeacons enumerateObjectsUsingBlock:^(CLBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    if (beacon.major &&
        beacon.minor) {
      
      OMNBeacon *newBeacon = [beacon omn_beacon];
      
      OMNBeacon *existingBeacon = existingBeaconsDictionary[newBeacon.key];
      
      if (existingBeacon) {
        
        [existingBeacon updateWithBeacon:beacon];
        
      }
      else {
        
        existingBeaconsDictionary[newBeacon.key] = newBeacon;
        
      }
      
    }
    
  }];
  
}

- (NSArray *)allBeacons {
  
  return [_existingBeaconsDictionary allValues];
  
}

- (BOOL)readyForProcessing {
  
  NSDictionary *existingBeaconsDictionary = [_existingBeaconsDictionary copy];
  __block BOOL hasNearTheTableBeacons = NO;
  [existingBeaconsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, OMNBeacon *beacon, BOOL *stop) {
    
    if (beacon.nearTheTable) {
      hasNearTheTableBeacons = YES;
      *stop = YES;
    }
    
  }];
  
  return hasNearTheTableBeacons;
  
}

@end
