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

@interface OMNWishMediator : NSObject

@property (nonatomic, weak, readonly) OMNMyOrderConfirmVC *rootVC;
@property (nonatomic, strong, readonly) OMNRestaurantMediator *restaurantMediator;

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator rootVC:(OMNMyOrderConfirmVC *)rootVC;

- (BOOL)canCreateWish;
- (NSArray *)selectedWishItems;
- (PMKPromise *)createWish;
- (PMKPromise *)getVisitor;
/**
 *  @return promise with visitor+wish
 */
- (PMKPromise *)createWishForVisitor:(OMNVisitor *)visitor;
- (PMKPromise *)processCreatedWishForVisitor:(OMNVisitor *)visitor;
- (void)didFinishWish;
- (void)closeTap;

- (NSString *)refreshOrdersTitle;
- (NSString *)wishHintText;

- (UIButton *)bottomButton;

@end
