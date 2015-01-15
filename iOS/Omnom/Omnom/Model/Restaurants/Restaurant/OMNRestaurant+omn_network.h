//
//  OMNRestaurant+omn_network.h
//  omnom
//
//  Created by tea on 30.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurant.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^OMNRestaurantsBlock)(NSArray *restaurants);
typedef void(^OMNRestaurantInfoBlock)(OMNRestaurantInfo *restaurantInfo);

@interface OMNRestaurant (omn_network)

+ (void)getRestaurantsForLocation:(CLLocationCoordinate2D)coordinate withCompletion:(OMNRestaurantsBlock)restaurantsBlock failure:(void(^)(OMNError *error))failureBlock;
- (void)createOrderForTableID:(NSString *)tableID products:(NSArray *)products block:(OMNOrderBlock)block failureBlock:(void(^)(NSError *error))failureBlock;
- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))failureBlock;

- (void)handleEnterEventWithCompletion:(dispatch_block_t)completionBlock;
- (void)handleAtTheTableEventWithCompletion:(dispatch_block_t)completionBlock;

- (void)leave;
- (void)entrance;
- (void)nearby;

@end

@interface NSObject (omn_restaurants)

- (NSArray *)omn_restaurants;
- (void)omn_decodeWithRestaurantsBlock:(OMNRestaurantsBlock)restaurantsBlock failureBlock:(void(^)(OMNError *error))failureBlock;

@end
