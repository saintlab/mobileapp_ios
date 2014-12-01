//
//  OMNLocationManager.h
//  omnom
//
//  Created by tea on 28.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^OMNLocationBlock)(CLLocationCoordinate2D coordinate);

@interface OMNLocationManager : NSObject

+ (instancetype)sharedManager;
- (void)getLocation:(OMNLocationBlock)block;

@end
