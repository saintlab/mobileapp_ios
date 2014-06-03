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

- (instancetype)init {
  self = [super init];
  if (self) {
    _existingBeaconsDictionary = [NSMutableDictionary dictionary];
    _atTheTableBeacons = [NSMutableArray array];
  }
  return self;
}

- (BOOL)updateWithFoundBeacons:(NSArray *)foundBeacons {
 
  NSMutableDictionary *existingBeaconsDictionary = _existingBeaconsDictionary;

  [foundBeacons enumerateObjectsUsingBlock:^(CLBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    if (beacon.major &&
        beacon.minor) {
      
      OMNBeacon *newBeacon = [beacon omn_beacon];
      
      OMNBeacon *existingBeacon = existingBeaconsDictionary[newBeacon.key];
      
      if (existingBeacon) {
        
        [existingBeacon updateWithBeacon:newBeacon];
        
      }
      else {
        
        existingBeaconsDictionary[newBeacon.key] = newBeacon;
        
      }
      
    }
    
  }];
  
  __block BOOL hasChanges = NO;
  [_existingBeaconsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, OMNBeacon *beacon, BOOL *stop) {
    
    if (beacon.atTheTable &&
        ![_atTheTableBeacons containsObject:beacon]) {
      
      [_atTheTableBeacons addObject:beacon];
      hasChanges = YES;
      
    }
    else if ([_atTheTableBeacons containsObject:beacon] &&
             !beacon.atTheTable){
      
      [_atTheTableBeacons removeObject:beacon];
      hasChanges = YES;
      
    }
    
  }];
  
  return hasChanges;
  
}

@end
