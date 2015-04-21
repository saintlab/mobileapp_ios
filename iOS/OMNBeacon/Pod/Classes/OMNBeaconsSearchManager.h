//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconRangingManager.h"
#import "OMNFoundBeacons.h"

typedef void(^OMNDidFindBeaconsBlock)(NSArray *beacons);

@interface OMNBeaconsSearchManager : NSObject

- (void)startSearchingWithCompletion:(OMNDidFindBeaconsBlock)didFindBeaconsBlock;
- (void)stop;

@end
