//
//  OMNRestaurant+omn_network.h
//  omnom
//
//  Created by tea on 30.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurant.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNWish.h"

typedef void(^OMNRestaurantsBlock)(NSArray *restaurants);
typedef void(^OMNRestaurantInfoBlock)(OMNRestaurantInfo *restaurantInfo);
typedef void(^OMNMenuBlock)(OMNMenu *menu);
typedef void(^OMNWishBlock)(OMNWish *wish);

@interface OMNRestaurant (omn_network)

+ (void)getRestaurantsForLocation:(CLLocationCoordinate2D)coordinate withCompletion:(OMNRestaurantsBlock)restaurantsBlock failure:(void(^)(OMNError *error))failureBlock;
/**
 *  curl -X POST  -H 'X-Authentication-Token: Ga7Rc1lBabcEIOoqd8MsSejzsroI01En' -H "Content-Type: application/json" -d '{ "internal_table_id":"2", "items":[{"id":"15ecf053-feea-46ae-ac94-9a4087a724a8-in-saintlab-iiko","quantity":"1", "modifiers": [{"id":"69c53de0-be11-4843-9628-fb1e01c9437e-in-saintlab-iiko","quantity":"1"}  ] }]}' http://omnom.laaaab.com/restaurants/saintlab-iiko/wishes
 *
 *  @param tableID      table ID or nil
 *  @param products     list of {"id":"", "quantity":"1", "modifiers":[{"id":"", "quantity":"1"}]} objects
 */
- (void)createWishForTable:(OMNTable *)table products:(NSArray *)products completionBlock:(OMNWishBlock)completionBlock failureBlock:(void(^)(OMNError *error))failureBlock;
- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))failureBlock;

- (void)handleEnterEventWithCompletion:(dispatch_block_t)completionBlock;
- (void)handleAtTheTableEventWithCompletion:(dispatch_block_t)completionBlock;

- (void)leaveWithCompletion:(dispatch_block_t)completionBlock;;
- (void)entranceWithCompletion:(dispatch_block_t)completionBlock;;
- (void)nearbyWithCompletion:(dispatch_block_t)completionBlock;;

- (void)getMenuWithCompletion:(OMNMenuBlock)completion;

@end

@interface NSObject (omn_restaurants)

- (NSArray *)omn_restaurants;
- (void)omn_decodeWithRestaurantsBlock:(OMNRestaurantsBlock)restaurantsBlock failureBlock:(void(^)(OMNError *error))failureBlock;

@end
