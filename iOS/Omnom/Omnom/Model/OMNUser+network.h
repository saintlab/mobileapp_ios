//
//  OMNUser+network.h
//  omnom
//
//  Created by tea on 28.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNError.h"
#import <PromiseKit.h>

@interface OMNUser (network)

+ (void)loginUsingData:(NSString *)data code:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(OMNError *error))failureBlock;

+ (void)recoverUsingData:(NSString *)data completion:(dispatch_block_t)completionBlock failure:(void (^)(OMNError *error))failureBlock;

+ (PMKPromise *)userWithToken:(NSString *)token;


- (void)confirmPhone:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(OMNError *error))failureBlock;

- (void)confirmPhoneResend:(dispatch_block_t)completion failure:(void (^)(OMNError *error))failureBlock;

- (void)loadImageWithCompletion:(dispatch_block_t)completion failure:(void (^)(OMNError *error))failureBlock;

- (void)registerWithCompletion:(dispatch_block_t)completion failure:(void (^)(OMNError *error))failureBlock;

- (PMKPromise *)updateUserInfoWithUserAndImage:(OMNUser *)user;

- (void)verifyPhoneCode:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(OMNError *error))failureBlock;

- (void)updateWithUser:(OMNUser *)user;

- (void)recoverWithCompletion:(void (^)(NSURL *url))completion failure:(void (^)(OMNError *error))failureBlock;

@end
