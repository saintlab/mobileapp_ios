//
//  OMNDeviceLocationManager.h
//  beacon
//
//  Created by tea on 15.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OMNDevicePositionBlock)(BOOL onTable);

@interface OMNDevicePositionManager : NSObject

@property (nonatomic, readonly) BOOL running;

+ (instancetype)sharedManager;
- (void)getDevicePosition:(OMNDevicePositionBlock)devicePositionBlock;
- (void)handleDeviceFaceUpPosition:(dispatch_block_t)block;
- (void)stop;

@end
