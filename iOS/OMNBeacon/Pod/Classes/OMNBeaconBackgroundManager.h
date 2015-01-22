//
//  GBeaconBackgroundManager.h
//  beacon
//
//  Created by tea on 03.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNBeacon;

/**
 This class is responible to handle background beacon finding, 
 */

@interface OMNBeaconBackgroundManager : NSObject

@property (nonatomic, copy) dispatch_block_t didEnterBeaconsRegionBlock;

+ (instancetype)manager;

@end

