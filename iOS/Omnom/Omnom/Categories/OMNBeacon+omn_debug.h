//
//  OMNBeacon+omn_debug.h
//  omnom
//
//  Created by tea on 24.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeacon.h"

@interface OMNBeacon (omn_debug)

+ (NSDictionary *)omn_debugDataFromNearestBeacons:(NSArray *)nearsetBeacons allBeacons:(NSArray *)allBeacons;

@end
