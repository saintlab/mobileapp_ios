//
//  GRestaurant.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GMenu.h"
#import "OMNOrder.h"

typedef void(^GRestaurantsBlock)(NSArray *restaurants);
typedef void(^GMenuBlock)(GMenu *menu);

@interface OMNRestaurant : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *image;

- (instancetype)initWithData:(id)data;

+ (void)getRestaurantList:(GRestaurantsBlock)restaurantsBlock error:(void(^)(NSError *error))errorBlock;

- (void)getMenu:(GMenuBlock)menuBlock error:(void(^)(NSError *error))errorBlock;

- (void)callWaiterForTableID:(NSString *)tableID success:(dispatch_block_t)success error:(void(^)(NSError *error))errorBlock;

- (void)getOrdersForTableID:(NSString *)tableID orders:(OMNOrdersBlock)orders error:(void(^)(NSError *error))errorBlock;

- (void)createOrderForTableID:(NSString *)tableID products:(NSArray *)products block:(OMNOrderBlock)block error:(void(^)(NSError *error))errorBlock;

@end
