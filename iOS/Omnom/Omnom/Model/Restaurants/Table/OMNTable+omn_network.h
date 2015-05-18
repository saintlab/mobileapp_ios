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
#import <PromiseKit.h>

@interface OMNTable (omn_network)

- (void)tableIn;
- (PMKPromise *)getOrders;
- (void)waiterCallWithCompletion:(void(^)(OMNError *error))completionBlock;
- (void)waiterCallStopWithFailure:(void(^)(OMNError *error))failureBlock;
- (PMKPromise *)newGuest;

@end
