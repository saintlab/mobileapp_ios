//
//  OMNPreorderMediator.h
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNWish.h"
#import "OMNMyOrderConfirmVC.h"
#import "OMNRestaurant+omn_network.h"
#import "OMNRestaurantMediator.h"

@interface OMNPreorderMediator : NSObject

@property (nonatomic, weak, readonly) OMNMyOrderConfirmVC *rootVC;
@property (nonatomic, strong, readonly) OMNRestaurantMediator *restaurantMediator;

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator rootVC:(OMNMyOrderConfirmVC *)rootVC;

- (void)createWish:(NSArray *)wishItems completionBlock:(OMNWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock;
- (void)processCreatedWish:(OMNWish *)wish;
- (void)didFinishWish;

- (NSString *)refreshOrdersTitle;
- (UIButton *)bottomButton;

@end
