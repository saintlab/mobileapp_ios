//
//  OMNVisitor.h
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeacon.h"
#import "OMNRestaurant.h"
#import "OMNTable.h"
#import "OMNConstants.h"

@class OMNVisitor;

typedef void(^OMNVisitorBlock)(OMNVisitor *visitor);
typedef void(^OMNVisitorsBlock)(NSArray *visitors);

extern NSString * const OMNOrderDidChangeNotification;
extern NSString * const OMNOrderDidCloseNotification;
//extern NSString * const OMNOrderDidPayNotification;

extern NSString * const OMNOrderKey;
extern NSString * const OMNOrderIndexKey;

@interface OMNVisitor : NSObject
<NSCoding>

@property (nonatomic, strong, readonly) NSDate *foundDate;
@property (nonatomic, strong) OMNBeacon *beacon;
@property (nonatomic, strong) OMNTable *table;
@property (nonatomic, strong) OMNRestaurant *restaurant;

@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, weak) OMNOrder *selectedOrder;
@property (nonatomic, assign) BOOL waiterIsCalled;

- (instancetype)initWithJsonData:(id)data;

- (void)updateWithVisitor:(OMNVisitor *)visitor;
- (BOOL)isSameRestaurant:(OMNVisitor *)visitor;
- (void)subscribeForTableEvents;
- (BOOL)readyForPush;
- (BOOL)expired;
- (NSString *)id;
- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock;
- (void)newGuestWithCompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock;

- (void)waiterCallWithFailure:(void(^)(NSError *error))failureBlock;
- (void)waiterCallStopWithFailure:(void(^)(NSError *error))failureBlock;
- (void)stopWaiterCall;

@end

@interface NSArray (omn_visitor)

- (NSArray *)omn_visitors;

@end
