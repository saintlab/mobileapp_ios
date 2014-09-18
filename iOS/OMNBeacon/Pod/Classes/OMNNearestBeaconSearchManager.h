//
//  OMNBeaconSearchManager.h
//  beacon
//
//  Created by tea on 16.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeacon.h"

@interface OMNNearestBeaconSearchManager : NSObject

- (void)findNearestBeacon:(void(^)(OMNBeacon *beacon))didFindNearestBeaconBlock failure:(dispatch_block_t)failureBlock;

- (void)stop;

@end
