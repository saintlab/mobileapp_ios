//
//  OMNOrder.h
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConstants.h"
#import "OMNOrderItem.h"
#import "OMNTip.h"
#import "OMNBill.h"

@class OMNOrder;

typedef void(^OMNOrdersBlock)(NSArray *orders);
typedef void(^OMNOrderBlock)(OMNOrder *order);
typedef void(^OMNBillBlock)(OMNBill *bill);
//typedef void(^OMNOrderPayURLBlock)(NSString *urlString);

@interface OMNOrder : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) long long amount;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *openTime;
@property (nonatomic, copy) NSString *modifiedTime;
@property (nonatomic, copy) NSString *tableId;
@property (nonatomic, copy) NSString *restaurant_id;
@property (nonatomic, copy) NSString *restarateurOrderId;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong, readonly) NSArray *tips;
@property (nonatomic, assign, readonly) double tipsThreshold;

@property (nonatomic, assign) long long toPayAmount;
@property (nonatomic, assign) long long tipAmount;

- (instancetype)initWithJsonData:(id)jsonData;

- (double)total;

- (void)deselectAll;

- (double)selectedItemsTotal;

/**
 https://github.com/saintlab/backend/tree/master/applications/omnom#create-restaurateur-order
 */
- (void)createBill:(OMNBillBlock)completion failure:(OMNErrorBlock)failureBlock;

@end
