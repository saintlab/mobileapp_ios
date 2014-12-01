//
//  OMNDeviceLocationManager.h
//  beacon
//
//  Created by tea on 15.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNDevicePositionManager : NSObject

@property (nonatomic, readonly) BOOL running;

- (void)handleDeviceFaceUpPosition:(dispatch_block_t)block;
- (void)stop;

@end
