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

@dynamic atTheTableBeacons;

- (instancetype)init {
  self = [super init];
  if (self) {
    _existingBeaconsDictionary = [NSMutableDictionary dictionary];
  }
  return self;
}

- (BOOL)updateWithBeacons:(NSArray *)foundBeacons {
 
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

- (NSArray *)atTheTableBeacons {
  
  NSMutableDictionary *rssiInfo = [NSMutableDictionary dictionary];
  [_existingBeaconsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, OMNBeacon *beacon, BOOL *stop) {
    
    if (beacon.averageRSSI > kBoardingRSSI) {
      rssiInfo[@(beacon.averageRSSI)] = beacon;
    }
    
  }];

  
  NSLog(@"%@", rssiInfo);
  
  if (rssiInfo.count == 0) {
    return nil;
  }
  
  return [rssiInfo allValues];
  
  /*
  NSArray *sortedRssi = [[rssiInfo allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
    return [obj2 compare:obj1];
  }];

  
  
  NSLog(@"%@", sortedRssi);
  
  NSMutableArray *atTheTableBeacons = [NSMutableArray array];
  return atTheTableBeacons;
   */
}

@end
