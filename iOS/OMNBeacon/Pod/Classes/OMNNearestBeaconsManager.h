//
//  OMNBeaconsManager.h
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void(^OMNFoundBeaconsBlock)(NSArray *foundBeacons);
typedef void(^OMNBeaconsManagerStatusBlock)(CLAuthorizationStatus status);

@interface OMNNearestBeaconsManager : NSObject 

@property (nonatomic, assign, readonly) BOOL isRanging;

- (instancetype)initWithStatusBlock:(OMNBeaconsManagerStatusBlock)statusBlock;

- (void)rangeNearestBeacons:(OMNFoundBeaconsBlock)block;

- (void)stop;

@end
