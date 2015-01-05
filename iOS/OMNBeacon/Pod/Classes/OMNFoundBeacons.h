//
//  OMNFoundBeacons.h
//  beacon
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNBeacon.h"

@interface OMNFoundBeacons : NSObject

@property (nonatomic, strong, readonly) NSArray *allBeacons;
@property (nonatomic, assign, readonly) BOOL readyForProcessing;

- (BOOL)updateWithBeacons:(NSArray *)foundBeacons;

@end
