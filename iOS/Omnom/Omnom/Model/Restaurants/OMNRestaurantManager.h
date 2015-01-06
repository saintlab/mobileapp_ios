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

+ (void)decodeBeacons:(NSArray *)beacons withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void(^)(OMNError *error))failureBlock;
+ (void)demoRestaurantWithCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void(^)(OMNError *error))failureBlock;
+ (void)decodeQR:(NSString *)qrCode withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void (^)(OMNError *))failureBlock;
+ (void)decodeHash:(NSString *)hash withCompletion:(OMNRestaurantsBlock)completionBlock failureBlock:(void (^)(OMNError *))failureBlock;

@end
