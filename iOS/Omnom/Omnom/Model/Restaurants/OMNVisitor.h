//
//  OMNVisitor.h
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit.h>
#import "OMNRestaurant.h"
//#import "OMNWish.h"
#import "OMNDelivery.h"
#import "OMNForbiddenWishProducts.h"

@class OMNRestaurantMediator;
@class OMNRestaurantActionsVC;

typedef void(^OMNWrongIDsBlock)(NSArray *wrongIDs);
typedef void(^OMNMenuBlock)(OMNMenu *menu);

@interface OMNVisitor : NSObject

@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;
@property (nonatomic, strong, readonly) OMNDelivery *delivery;

+ (instancetype)visitorWithRestaurant:(OMNRestaurant *)restaurant delivery:(OMNDelivery *)delivery;
- (OMNRestaurantMediator *)mediatorWithRootVC:(OMNRestaurantActionsVC *)rootVC;
- (NSString *)tags;

- (PMKPromise *)enter:(UIViewController *)rootVC;

- (NSString *)restarantCardButtonTitle;
- (NSString *)restarantCardButtonIcon;

@end
