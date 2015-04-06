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
typedef void(^OMNProductItemsBlock)(NSArray *productItems);
typedef void(^OMNAddressesBlock)(NSArray *addresses);
typedef void(^OMNRestaurantInfoBlock)(OMNRestaurantInfo *restaurantInfo);
typedef void(^OMNMenuBlock)(OMNMenu *menu);

@interface OMNRestaurant (omn_network)

+ (void)getRestaurantsForLocation:(CLLocationCoordinate2D)coordinate withCompletion:(OMNRestaurantsBlock)restaurantsBlock failure:(void(^)(OMNError *error))failureBlock;
- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))failureBlock;
- (void)getDeliveryAddressesWithCompletion:(OMNAddressesBlock)addressesBlock failure:(void(^)(OMNError *error))failureBlock;

- (void)handleEnterEventWithCompletion:(dispatch_block_t)completionBlock;
- (void)handleAtTheTableEventWithCompletion:(dispatch_block_t)completionBlock;

- (void)leaveWithCompletion:(dispatch_block_t)completionBlock;;
- (void)entranceWithCompletion:(dispatch_block_t)completionBlock;;
- (void)nearbyWithCompletion:(dispatch_block_t)completionBlock;;

- (void)getMenuWithCompletion:(OMNMenuBlock)completion;
- (void)getRecommendationItems:(OMNProductItemsBlock)productItemsBlock error:(void(^)(OMNError *error))errorBlock;

@end

@interface NSObject (omn_restaurants)

- (NSArray *)omn_restaurants;
- (void)omn_decodeWithRestaurantsBlock:(OMNRestaurantsBlock)restaurantsBlock failureBlock:(void(^)(OMNError *error))failureBlock;

@end
