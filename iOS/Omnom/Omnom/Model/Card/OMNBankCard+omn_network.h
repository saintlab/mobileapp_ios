//
//  OMNBankCard+omn_network.h
//  omnom
//
//  Created by tea on 17.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBankCard.h"
#import <PromiseKit.h>

@interface OMNBankCard (omn_network)

- (PMKPromise *)omn_delete;
+ (void)getCardsWithCompletion:(void(^)(NSArray *cards))completionBlock failure:(void(^)(NSError *error))failureBlock;

@end

@interface NSDictionary (omn_decodeCardData)

- (void)decodeCardData:(void(^)(NSArray *))completionBlock failure:(void(^)(NSError *))failureBlock;

@end
