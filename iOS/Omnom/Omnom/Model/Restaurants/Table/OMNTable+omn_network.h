//
//  OMNTable+omn_network.h
//  omnom
//
//  Created by tea on 30.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTable.h"
#import "OMNOrder.h"

@interface OMNTable (omn_network)

- (void)tableInWithFailure:(void(^)(NSError *error))failureBlock;
- (void)getOrders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock;

@end
