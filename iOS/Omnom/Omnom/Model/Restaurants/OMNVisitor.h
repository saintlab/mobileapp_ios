//
//  OMNVisitor.h
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurant.h"
#import "OMNRestaurantMediator.h"
#import "OMNWish.h"
#import "OMNDelivery.h"

@class OMNVisitor;

typedef void(^OMNVisitorWishBlock)(OMNVisitor *visitor);
typedef void(^OMNWrongIDsBlock)(NSArray *wrongIDs);

@interface OMNVisitor : NSObject

@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;
@property (nonatomic, strong, readonly) OMNDelivery *delivery;
@property (nonatomic, strong, readonly) OMNWish *wish;

+ (instancetype)visitorWithRestaurant:(OMNRestaurant *)restaurant delivery:(OMNDelivery *)delivery;
- (instancetype)visitorWithWish:(OMNWish *)wish;
- (OMNRestaurantMediator *)mediatorWithRootVC:(OMNRestaurantActionsVC *)rootVC;

/**
 *  curl -X POST  -H 'X-Authentication-Token: Ga7Rc1lBabcEIOoqd8MsSejzsroI01En' -H "Content-Type: application/json" -d '{ "internal_table_id":"2", "items":[{"id":"15ecf053-feea-46ae-ac94-9a4087a724a8-in-saintlab-iiko","quantity":"1", "modifiers": [{"id":"69c53de0-be11-4843-9628-fb1e01c9437e-in-saintlab-iiko","quantity":"1"}  ] }]}' http://omnom.laaaab.com/restaurants/saintlab-iiko/wishes
 https://github.com/saintlab/backend/issues/1402
 *
 *  @param wishItems     list of {"id":"", "quantity":"1", "modifiers":[{"id":"", "quantity":"1"}]} objects
 */
- (void)createWish:(NSArray *)wishItems completionBlock:(OMNVisitorWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock;

@end
