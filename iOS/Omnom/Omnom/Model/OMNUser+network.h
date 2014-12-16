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

@interface OMNUser (network)

+ (void)loginUsingData:(NSString *)data code:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(OMNError *error))failureBlock;

+ (void)recoverUsingData:(NSString *)data completion:(dispatch_block_t)completionBlock failure:(void (^)(OMNError *error))failureBlock;

+ (void)userWithToken:(NSString *)token user:(OMNUserBlock)userBlock failure:(void (^)(OMNError *error))failureBlock;


- (void)confirmPhone:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(OMNError *error))failureBlock;

- (void)confirmPhoneResend:(dispatch_block_t)completion failure:(void (^)(OMNError *error))failureBlock;

- (void)loadImageWithCompletion:(dispatch_block_t)completion failure:(void (^)(OMNError *error))failureBlock;

- (void)registerWithCompletion:(dispatch_block_t)completion failure:(void (^)(OMNError *error))failureBlock;

- (void)logCoordinates:(CLLocationCoordinate2D)coordinates;

- (void)updateUserInfoWithUserAndImage:(OMNUser *)user withCompletion:(dispatch_block_t)completion failure:(void(^)(OMNError *))failureBlock;

- (void)uploadImage:(UIImage *)image withCompletion:(void (^)(OMNUser *user))completion progress:(void (^)(CGFloat percent))progressBlock failure:(void (^)(OMNError *error))failureBlock;

- (void)verifyPhoneCode:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(OMNError *error))failureBlock;

- (void)updateWithUser:(OMNUser *)user;

- (void)recoverWithCompletion:(void (^)(NSURL *url))completion failure:(void (^)(OMNError *error))failureBlock;

@end
