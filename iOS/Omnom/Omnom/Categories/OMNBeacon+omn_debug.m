//
//  OMNBeacon+omn_debug.m
//  omnom
//
//  Created by tea on 24.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeacon+omn_debug.h"

@implementation OMNBeacon (omn_debug)

+ (NSDictionary *)debugDataFromBeacons:(NSArray *)beacons {
  
  NSMutableDictionary *beaconsDebugData = [NSMutableDictionary dictionaryWithCapacity:beacons.count];
  [beacons enumerateObjectsUsingBlock:^(OMNBeacon *beacon, NSUInteger idx, BOOL *stop) {
    
    beaconsDebugData[beacon.key] = beacon.JSONObject;
    
  }];
  return beaconsDebugData;
  
}

@end
