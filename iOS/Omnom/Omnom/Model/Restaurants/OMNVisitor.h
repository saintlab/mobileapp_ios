//
//  OMNVisitor.h
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurant.h"

@interface OMNVisitor : NSObject

@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;
@property (nonatomic, strong) OMNTable *table;
@property (nonatomic, weak) OMNOrder *selectedOrder;
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, assign) BOOL waiterIsCalled;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;
- (NSString *)tableName;
- (NSUInteger)selectedOrderIndex;
- (BOOL)showTableButton;
- (BOOL)hasOrders;
- (BOOL)ordersHasProducts;
- (void)updateOrdersIfNeeded;
- (long long)ordersTotalAmount;

- (void)waiterCall;
- (void)waiterCallStop;

@end
