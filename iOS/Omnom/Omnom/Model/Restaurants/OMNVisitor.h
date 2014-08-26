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

typedef void(^OMNVisitorBlock)(OMNVisitor *decodeBeacon);
typedef void(^OMNVisitorsBlock)(NSArray *decodeBeacons);

@interface OMNVisitor : NSObject
<NSCoding>

@property (nonatomic, strong) NSDate *foundDate;
@property (nonatomic, strong) OMNBeacon *beacon;
@property (nonatomic, strong) OMNTable *table;
@property (nonatomic, strong) OMNRestaurant *restaurant;

@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, weak) OMNOrder *selectedOrder;

- (instancetype)initWithJsonData:(id)data;

- (BOOL)readyForPush;
- (NSString *)id;
- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock;
- (void)newGuestWithCompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock;

@end
