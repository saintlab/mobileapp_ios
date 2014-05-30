//
//  OMNOrder.h
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConstants.h"
#import "OMNOrderItem.h"

@class OMNOrder;

typedef void(^OMNOrdersBlock)(NSArray *orders);
typedef void(^OMNOrderBlock)(OMNOrder *order);
typedef void(^OMNOrderPayURLBlock)(NSString *urlString);

@interface OMNOrder : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger amount;
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

@property (nonatomic, assign) double toPayAmount;

- (instancetype)initWithData:(id)data;

- (double)total;

- (void)deselectAll;

- (double)selectedItemsTotal;

+ (void)ordersWithBlock:(OMNOrdersBlock)ordersBlock;

- (void)getPaymentURL:(OMNOrderPayURLBlock)completion failure:(OMNErrorBlock)failureBlock;
/**
 https://github.com/saintlab/backend/tree/master/applications/omnom#create-restaurateur-order
 */
- (void)createAcquiringOrder:(OMNOrderBlock)completion failure:(OMNErrorBlock)failureBlock;

@end
