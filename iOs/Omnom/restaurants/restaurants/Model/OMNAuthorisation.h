//
//  OMNAuthorisation.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConstants.h"

@class OMNUser;

typedef void(^OMNUserBlock)(OMNUser *user);
typedef void(^OMNTokenBlock)(NSString *token);

@interface OMNAuthorisation : NSObject

@property (nonatomic, copy, readonly) NSString *token;

@property (nonatomic, copy, readonly) NSString *installId;

@property (nonatomic, strong) dispatch_block_t logoutCallback;

+ (instancetype)authorisation;

- (void)updateToken:(NSString *)newToken;

- (void)checkTokenWithBlock:(void (^)(BOOL tokenIsValid))block;

@end

@interface NSDictionary (omn_tokenResponse)

- (void)decodeToken:(OMNTokenBlock)complition failure:(OMNErrorBlock)failureBlock;

@end
