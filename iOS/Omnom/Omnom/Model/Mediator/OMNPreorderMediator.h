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
#import "OMNRestaurant.h"

@interface OMNPreorderMediator : NSObject

@property (nonatomic, copy) dispatch_block_t didFinishBlock;

- (instancetype)initWithRootVC:(OMNMyOrderConfirmVC *)myOrderConfirmVC restaurant:(OMNRestaurant *)restaurant;

- (void)processWish:(OMNWish *)wish;
- (void)completeOrdresCall;

@end
