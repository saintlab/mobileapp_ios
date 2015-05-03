//
//  OMNBeaconSearchManager.h
//  beacon
//
//  Created by tea on 16.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <PromiseKit.h>

@interface OMNNearestBeaconSearchManager : NSObject

+ (PMKPromise *)findAndProcessNearestBeacons;

@end
