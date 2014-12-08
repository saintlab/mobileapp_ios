//
//  OMNUser+network.h
//  omnom
//
//  Created by tea on 28.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"
#import <CoreLocation/CoreLocation.h>

@interface OMNUser (network)


+ (void)loginUsingData:(NSString *)data code:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock;

+ (void)recoverUsingData:(NSString *)data completion:(dispatch_block_t)completionBlock failure:(void (^)(NSError *error))failureBlock;

+ (void)userWithToken:(NSString *)token user:(OMNUserBlock)userBlock failure:(void (^)(NSError *error))failureBlock;


- (void)confirmPhone:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock;

- (void)confirmPhoneResend:(dispatch_block_t)completion failure:(void (^)(NSError *error))failureBlock;

- (void)loadImageWithCompletion:(dispatch_block_t)completion failure:(void (^)(NSError *error))failureBlock;

- (void)registerWithCompletion:(dispatch_block_t)completion failure:(void (^)(NSError *error))failureBlock;

- (void)updateCoordinates:(CLLocationCoordinate2D)coordinates;

- (void)updateUserInfoWithUserAndImage:(OMNUser *)user withCompletion:(dispatch_block_t)completion failure:(void(^)(NSError *))failureBlock;

- (void)uploadImage:(UIImage *)image withCompletion:(dispatch_block_t)completion progress:(void (^)(CGFloat percent))progressBlock failure:(void (^)(NSError *error))failureBlock;

- (void)verifyPhoneCode:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock;

- (void)updateWithUser:(OMNUser *)user;

- (void)recoverWithCompletion:(void (^)(NSURL *url))completion failure:(void (^)(NSError *error))failureBlock;

@end

@interface NSObject (omn_userError)

- (NSError *)omn_userError;
- (BOOL)omn_isSuccessResponse;

@end
