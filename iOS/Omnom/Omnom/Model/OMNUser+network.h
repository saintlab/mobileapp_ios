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

- (void)registerWithCompletion:(dispatch_block_t)completion failure:(void (^)(NSError *error))failureBlock;

- (void)confirmPhone:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock;

- (void)confirmPhoneResend:(dispatch_block_t)completion failure:(void (^)(NSError *error))failureBlock;
- (void)verifyPhoneCode:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock;
+ (void)loginUsingData:(NSString *)data code:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock;
+ (void)recoverUsingData:(NSString *)data completion:(dispatch_block_t)completionBlock failure:(void (^)(NSError *error))failureBlock;
+ (void)userWithToken:(NSString *)token user:(OMNUserBlock)userBlock failure:(void (^)(NSError *error))failureBlock;
- (void)updateCoordinates:(CLLocationCoordinate2D)coordinates;

@end
