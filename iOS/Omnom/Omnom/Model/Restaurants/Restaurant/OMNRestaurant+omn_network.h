//
//  OMNRestaurant+omn_network.h
//  omnom
//
//  Created by tea on 30.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurant.h"
#import <CoreLocation/CoreLocation.h>
#import <PromiseKit.h>

typedef void(^OMNRestaurantsBlock)(NSArray *restaurants);
typedef void(^OMNRestaurantBlock)(OMNRestaurant *restaurant);
typedef void(^OMNProductItemsBlock)(NSArray *productItems);
typedef void(^OMNAddressesBlock)(NSArray *addresses);
typedef void(^OMNRestaurantInfoBlock)(OMNRestaurantInfo *restaurantInfo);

@interface OMNRestaurant (omn_network)

+ (void)restaurantWithID:(NSString *)restaurantID withCompletion:(OMNRestaurantBlock)restaurantBlock failure:(void(^)(OMNError *error))failureBlock;
+ (void)getRestaurantsForLocation:(CLLocationCoordinate2D)coordinate withCompletion:(OMNRestaurantsBlock)restaurantsBlock failure:(void(^)(OMNError *error))failureBlock;
- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))failureBlock;
- (void)getDeliveryAddressesWithCompletion:(OMNAddressesBlock)addressesBlock failure:(void(^)(OMNError *error))failureBlock;

- (PMKPromise *)foundInBackground;
- (PMKPromise *)handleEnterEvent;
- (PMKPromise *)handleAtTheTableEvent;

- (void)leaveWithCompletion:(dispatch_block_t)completionBlock;;
- (PMKPromise *)entrance;
- (void)nearbyWithCompletion:(dispatch_block_t)completionBlock;;

- (void)getRecommendationItems:(OMNProductItemsBlock)productItemsBlock error:(void(^)(OMNError *error))errorBlock;

@end

@interface NSObject (omn_restaurants)

- (NSArray *)omn_restaurants;
- (void)omn_decodeWithRestaurantsBlock:(OMNRestaurantsBlock)restaurantsBlock failureBlock:(void(^)(OMNError *error))failureBlock;

@end
