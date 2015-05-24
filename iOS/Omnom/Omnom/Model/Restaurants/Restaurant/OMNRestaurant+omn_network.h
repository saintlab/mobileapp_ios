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

+ (PMKPromise *)restaurantWithID:(NSString *)restaurantID;
+ (PMKPromise *)restaurantsForLocation:(CLLocationCoordinate2D)coordinate;
- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))failureBlock;
- (void)getDeliveryAddressesWithCompletion:(OMNAddressesBlock)addressesBlock failure:(void(^)(OMNError *error))failureBlock;

- (PMKPromise *)foundInBackground;
- (PMKPromise *)handleEnterEvent;
- (PMKPromise *)handleAtTheTableEvent;

- (PMKPromise *)leave;
- (PMKPromise *)entrance;

- (void)getRecommendationItems:(OMNProductItemsBlock)productItemsBlock error:(void(^)(OMNError *error))errorBlock;

@end

@interface NSObject (omn_restaurants)

- (NSArray *)omn_restaurants;
- (NSArray *)omn_decodeRestaurants;

@end
