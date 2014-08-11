//
//  GRestaurant.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenu.h"
#import "OMNOrder.h"

typedef void(^GRestaurantsBlock)(NSArray *restaurants);
typedef void(^GMenuBlock)(OMNMenu *menu);
typedef void(^OMNImageBlock)(UIImage *image);

@interface OMNRestaurant : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *image;

@property (nonatomic, strong) UIColor *background_color;
@property (nonatomic, strong) NSString *background_imageUrl;
@property (nonatomic, strong) NSString *logoUrl;

@property (nonatomic, strong) UIImage *logo;
@property (nonatomic, strong) UIImage *background;

- (instancetype)initWithData:(id)data;

+ (void)getRestaurantList:(GRestaurantsBlock)restaurantsBlock error:(void(^)(NSError *error))errorBlock;

- (void)getMenu:(GMenuBlock)menuBlock error:(void(^)(NSError *error))errorBlock;

- (void)waiterCallForTableID:(NSString *)tableID completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock;

- (void)waiterCallStopCompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock;

- (void)newGuestForTableID:(NSString *)tableID completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock;

- (void)getOrdersForTableID:(NSString *)tableID orders:(OMNOrdersBlock)orders error:(void(^)(NSError *error))errorBlock;

- (void)createOrderForTableID:(NSString *)tableID products:(NSArray *)products block:(OMNOrderBlock)block error:(void(^)(NSError *error))errorBlock;

- (void)loadLogo:(OMNImageBlock)imageBlock;
- (void)loadBackground:(OMNImageBlock)imageBlock;

@end
