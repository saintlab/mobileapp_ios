//
//  OMNUser.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConstants.h"

@class OMNUser;

typedef void(^OMNUserBlock)(OMNUser *user);

@interface OMNUser : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSDate *birthDate;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) BOOL phone_validated;
@property (nonatomic, assign) BOOL email_validated;

+ (instancetype)userWithPhone:(NSString *)phone;

- (instancetype)initWithData:(id)data;

- (void)registerWithCompletion:(dispatch_block_t)completion failure:(void (^)(NSError *error))failureBlock;

- (void)confirmPhone:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock;

- (void)confirmPhoneResend:(dispatch_block_t)completion failure:(void (^)(NSError *error))failureBlock;

+ (void)loginUsingData:(NSString *)data code:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock;
+ (void)recoverUsingData:(NSString *)data completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock;
+ (void)userWithToken:(NSString *)token user:(OMNUserBlock)userBlock failure:(void (^)(NSError *error))failureBlock;

@end

@interface NSString (omn_validPhone)

- (BOOL)omn_isValidPhone;
- (BOOL)omn_isValidEmail;

@end

