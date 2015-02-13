//
//  OMNTable+omn_network.h
//  omnom
//
//  Created by tea on 30.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTable.h"
#import "OMNOrder.h"
#import "OMNError.h"

@interface OMNTable (omn_network)

- (void)tableIn;
- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(OMNError *error))errorBlock;
- (void)getProductItems:(dispatch_block_t)pi error:(void(^)(OMNError *error))errorBlock;
- (void)waiterCallWithCompletion:(void(^)(OMNError *error))completionBlock;
- (void)waiterCallStopWithFailure:(void(^)(OMNError *error))failureBlock;
- (void)newGuestWithCompletion:(dispatch_block_t)completionBlock;

@end
