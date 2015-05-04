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
#import <PromiseKit.h>
typedef void(^OMNRestaurantsBlock)(NSArray *restaurants);

@interface OMNRestaurantManager : NSString

+ (void)demoRestaurantWithCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void(^)(OMNError *error))failureBlock;
+ (void)decodeHash:(NSString *)hash withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void (^)(OMNError *))failureBlock;

+ (PMKPromise *)decodeQR:(NSString *)qr;
+ (PMKPromise *)decodeBeacons:(NSArray *)beacons;
+ (PMKPromise *)processBackgroundBeacons:(NSArray *)beacons;

+ (instancetype)sharedManager;

@end
