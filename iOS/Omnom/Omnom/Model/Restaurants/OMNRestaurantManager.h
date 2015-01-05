//
//  OMNRestaurantManager.h
//  omnom
//
//  Created by tea on 29.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNBeacon.h"
#import "OMNError.h"
#import "OMNRestaurant.h"

typedef void(^OMNRestaurantsBlock)(NSArray *restaurants);

@interface OMNRestaurantManager : NSString

+ (instancetype)sharedManager;
+ (void)decodeBeacons:(NSArray *)beacons withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void(^)(OMNError *error))failureBlock;

- (void)waiterCallWithFailure:(void(^)(NSError *error))failureBlock;
- (void)waiterCallStopWithFailure:(void(^)(NSError *error))failureBlock;

@end
