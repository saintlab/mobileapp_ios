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
#import "OMNOrderPaid.h"
#import "OMNGuest.h"

@class OMNOrder;

typedef void(^OMNOrdersBlock)(NSArray *orders);
typedef void(^OMNOrderBlock)(OMNOrder *order);
typedef void(^OMNBillBlock)(OMNBill *bill);

typedef NS_ENUM(NSInteger, TipType) {
  kTipTypeDefault = 0,
  kTipTypeCustom,
  kTipTypeCustomPercent,
  kTipTypeCustomAmount,
};

typedef NS_ENUM(NSInteger, SplitType) {
  kSplitTypeNone = 0,
  kSplitTypePercent,
  kSplitTypeOrders,
  kSplitTypeNumberOfGuests,
};

extern NSString *stringFromTipType(TipType tipType);
extern NSString *stringFromSplitType(SplitType splitType);

@interface OMNOrder : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *openTime;
@property (nonatomic, copy) NSString *modifiedTime;
@property (nonatomic, copy) NSString *table_id;
@property (nonatomic, copy) NSString *restaurant_id;
@property (nonatomic, copy) NSString *restarateurOrderId;

@property (nonatomic, strong, readonly) NSArray *guests;

@property (nonatomic, strong, readonly) NSMutableArray *tips;
@property (nonatomic, assign, readonly) long long percentTipsThreshold;

@property (nonatomic, strong) OMNOrderPaid *paid;
@property (nonatomic, strong) OMNBill *bill;

@property (nonatomic, strong, readonly) OMNTip *customTip;
@property (nonatomic, assign, readonly) long long expectedValue;
@property (nonatomic, assign, readonly) long long enteredAmountWithTips;
@property (nonatomic, assign, readonly) long long tipAmount;
@property (nonatomic, assign) long long enteredAmount;

@property (nonatomic, assign) TipType tipType;
@property (nonatomic, assign) SplitType splitType;

@property (nonatomic, assign) NSInteger selectedTipIndex;

- (instancetype)initWithJsonData:(id)jsonData;
- (void)updateWithOrder:(OMNOrder *)order;
- (BOOL)paymentValueIsTooHigh;
- (BOOL)hasSelectedItems;
- (long long)totalAmount;
- (long long)selectedItemsTotal;

- (void)selectionDidChange;
- (void)deselectAllItems;
- (void)resetEnteredAmount;

@end
