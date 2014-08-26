//
//  OMNDecodeBeacon.h
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeacon.h"
#import "OMNRestaurant.h"
#import "OMNConstants.h"

@class OMNDecodeBeacon;

typedef void(^OMNDecodeBeaconBlock)(OMNDecodeBeacon *decodeBeacon);
typedef void(^OMNDecodeBeaconsBlock)(NSArray *decodeBeacons);

@interface OMNDecodeBeacon : NSObject
<NSCoding>

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *tableId;
@property (nonatomic, copy) NSString *restaurantId;
@property (nonatomic, strong) NSDate *foundDate;
@property (nonatomic, assign, readonly) BOOL demo;

@property (nonatomic, strong) OMNRestaurant *restaurant;
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, weak) OMNOrder *selectedOrder;

- (instancetype)initWithJsonData:(id)data;

- (BOOL)readyForPush;

- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock;
- (void)newGuestWithCompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock;

@end
