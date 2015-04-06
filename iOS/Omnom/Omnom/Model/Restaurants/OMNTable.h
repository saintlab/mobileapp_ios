//
//  OMNTable.h
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNOrder.h"

extern NSString * const OMNTableOrdersDidChangeNotification;

@interface OMNTable : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *internal_id;
@property (nonatomic, copy) NSString *restaurant_id;
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, weak) OMNOrder *selectedOrder;
@property (nonatomic, assign) BOOL waiterIsCalled;

- (instancetype)initWithJsonData:(id)data;

- (NSString *)name;
- (NSUInteger)selectedOrderIndex;
- (BOOL)hasOrders;
- (BOOL)ordersHasProducts;
- (void)updateOrdersIfNeeded;
- (long long)ordersTotalAmount;
- (void)waiterCall;
- (void)waiterCallStop;
- (void)join;

@end

@interface NSObject (omn_tables)

- (NSArray *)omn_tables;

@end