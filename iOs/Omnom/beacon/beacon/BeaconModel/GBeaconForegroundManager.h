//
//  GBeaconForegroundManager.h
//  beacon
//
//  Created by tea on 03.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeaconsManager.h"

@interface GBeaconForegroundManager : NSObject

@property (nonatomic, strong, readonly) OMNBeaconsManager *beaconManager;

+ (instancetype)manager;

- (void)startMonitoring;

- (void)stopMonitoring;


@end
