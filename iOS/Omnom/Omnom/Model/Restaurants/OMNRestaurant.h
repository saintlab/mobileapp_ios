//
//  GRestaurant.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenu.h"
#import "OMNOrder.h"
#import "OMNRestaurantInfo.h"
#import "OMNPushTexts.h"
#import "OMNRestaurantDecoration.h"
#import "OMNRestaurantSettings.h"
#import "OMNError.h"
#import "OMNRestaurantAddress.h"
#import "OMNRestaurantSchedules.h"

typedef void(^OMNRestaurantsBlock)(NSArray *restaurants);
typedef void(^OMNRestaurantInfoBlock)(OMNRestaurantInfo *restaurantInfo);

@interface OMNRestaurant : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL is_demo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, strong) OMNRestaurantDecoration *decoration;
@property (nonatomic, strong, readonly) OMNRestaurantAddress *address;
@property (nonatomic, strong) OMNPushTexts *mobile_texts;
@property (nonatomic, strong, readonly) OMNRestaurantSettings *settings;
@property (nonatomic, strong, readonly) OMNRestaurantSchedules *schedules;
@property (nonatomic, strong) OMNRestaurantInfo *info;

- (instancetype)initWithJsonData:(id)jsonData;

+ (void)getRestaurants:(OMNRestaurantsBlock)restaurantsBlock failure:(void(^)(OMNError *error))failureBlock;

- (void)createOrderForTableID:(NSString *)tableID products:(NSArray *)products block:(OMNOrderBlock)block failureBlock:(void(^)(NSError *error))failureBlock;

- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))failureBlock;

@end
