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

typedef void(^GRestaurantsBlock)(NSArray *restaurants);
typedef void(^OMNRestaurantInfoBlock)(OMNRestaurantInfo *restaurantInfo);
typedef void(^GMenuBlock)(OMNMenu *menu);

@interface OMNRestaurant : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL is_demo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, strong) OMNRestaurantDecoration *decoration;

//@property (nonatomic, strong) UIColor *background_color;
//@property (nonatomic, strong) NSString *background_imageUrl;
//@property (nonatomic, strong) NSString *logoUrl;
//@property (nonatomic, strong) UIImage *logo;
//@property (nonatomic, strong) UIImage *background;
@property (nonatomic, strong) OMNPushTexts *mobile_texts;

- (instancetype)initWithJsonData:(id)jsonData;

+ (void)getRestaurantList:(GRestaurantsBlock)restaurantsBlock error:(void(^)(NSError *error))errorBlock;

- (void)createOrderForTableID:(NSString *)tableID products:(NSArray *)products block:(OMNOrderBlock)block error:(void(^)(NSError *error))errorBlock;

- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))errorBlock;

@end
