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
- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock;
- (void)waiterCallWithCompletion:(void(^)(OMNError *error))completionBlock;
- (void)waiterCallStopWithFailure:(void(^)(OMNError *error))failureBlock;

@end
