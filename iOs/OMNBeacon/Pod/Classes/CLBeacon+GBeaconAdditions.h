//
//  CLBeacon+GBeaconAdditions.h
//  beacon
//
//  Created by tea on 06.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "OMNBeacon.h"

@interface CLBeacon (OMNBeaconAdditions)

- (OMNBeacon *)omn_beacon;

@end
