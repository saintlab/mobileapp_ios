//
//  OMNOrder+network.h
//  omnom
//
//  Created by tea on 07.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

@interface OMNOrder (network)

/**
https://github.com/saintlab/backend/tree/master/applications/omnom#bill
 */
- (void)createBill:(OMNBillBlock)completion failure:(void (^)(NSError *error))failureBlock;

- (void)billCall:(dispatch_block_t)completionBlock failure:(void (^)(NSError *error))failureBlock;
- (void)billCallStop:(dispatch_block_t)completionBlock failure:(void (^)(NSError *error))failureBlock;

@end
