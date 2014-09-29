//
//  OMNVisitor+network.h
//  omnom
//
//  Created by tea on 29.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNVisitor.h"

typedef void(^OMNVisitorBlock)(OMNVisitor *visitor);
typedef void(^OMNVisitorsBlock)(NSArray *visitors);

@interface OMNVisitor (omn_network)

- (void)updateWithVisitor:(OMNVisitor *)visitor;

- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock;
- (void)newGuestWithCompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock;

- (void)waiterCallWithFailure:(void(^)(NSError *error))failureBlock;
- (void)waiterCallStopWithFailure:(void(^)(NSError *error))failureBlock;
- (void)stopWaiterCall;

@end