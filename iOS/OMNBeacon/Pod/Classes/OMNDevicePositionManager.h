//
//  OMNDeviceLocationManager.h
//  beacon
//
//  Created by tea on 15.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit.h>

typedef void(^OMNDevicePositionBlock)(BOOL onTable);

@interface OMNDevicePositionManager : NSObject

+ (PMKPromise *)getAccelerometerData;
+ (PMKPromise *)onTable;

@end
