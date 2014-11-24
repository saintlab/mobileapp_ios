//
//  OMNBeacon+omn_debug.m
//  omnom
//
//  Created by tea on 24.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeacon+omn_debug.h"

@implementation OMNBeacon (omn_debug)

+ (NSDictionary *)omn_debugDataFromNearestBeacons:(NSArray *)nearsetBeacons allBeacons:(NSArray *)allBeacons {
  
  NSDictionary *nearstBeaconsRSSIData = [self debugDataFromBeacons:nearsetBeacons];
  NSDictionary *allBeaconsBeaconsRSSIData = [self debugDataFromBeacons:allBeacons];
  return @{@"nearstBeacons" : nearstBeaconsRSSIData,
           @"allBeacons" : allBeaconsBeaconsRSSIData};
  
}

+ (NSDictionary *)debugDataFromBeacons:(NSArray *)beacons {
  
  NSMutableDictionary *beaconsRSSIData = [NSMutableDictionary dictionaryWithCapacity:beacons.count];
  [beacons enumerateObjectsUsingBlock:^(OMNBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    if ([beacon isKindOfClass:[OMNBeacon class]]) {
    
      beaconsRSSIData[beacon.key] = @(beacon.averageRSSI);
      
    }
    
  }];
  return beaconsRSSIData;
  
}

@end
