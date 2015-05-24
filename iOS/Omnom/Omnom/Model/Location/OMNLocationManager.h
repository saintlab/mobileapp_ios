//
//  OMNLocationManager.h
//  omnom
//
//  Created by tea on 28.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <PromiseKit.h>

@interface OMNLocationManager : NSObject

+ (instancetype)sharedManager;
- (PMKPromise *)getLocation;

@end
