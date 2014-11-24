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

- (NSArray *)allBeacons {
  
  return [_existingBeaconsDictionary allValues];
  
}

- (NSArray *)atTheTableBeacons {
  
  NSDictionary *existingBeaconsDictionary = [_existingBeaconsDictionary copy];
  NSMutableArray *atTheTableBeacons = [NSMutableArray array];
  __block NSInteger maxRSSI = NSIntegerMin;
  
  NSLog(@"existingBeaconsDictionary>%@", existingBeaconsDictionary);
  
  [existingBeaconsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, OMNBeacon *beacon, BOOL *stop) {
    
    if (beacon.atTheTable) {
      maxRSSI = MAX(maxRSSI, beacon.totalRSSI);
      [atTheTableBeacons addObject:beacon];
    }
    
  }];

  const NSInteger kboardingRSSI = 50;
  NSMutableArray *conditionalBeacons = [NSMutableArray array];
  [atTheTableBeacons enumerateObjectsUsingBlock:^(OMNBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    if (beacon.totalRSSI > (maxRSSI - kboardingRSSI)) {
      [conditionalBeacons addObject:beacon];
    }
    
  }];
  
  
  return [conditionalBeacons copy];

}

@end
