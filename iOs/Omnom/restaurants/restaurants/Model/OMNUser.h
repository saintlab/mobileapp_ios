//
//  OMNUser.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConstants.h"
#import "OMNAuthorisation.h"

typedef void(^OMNUserBlock)(OMNUser *user);

@interface OMNUser : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) BOOL phone_validated;
@property (nonatomic, assign) BOOL email_validated;

+ (instancetype)userWithPhone:(NSString *)phone;

- (instancetype)initWithData:(id)data;

- (void)registerWithComplition:(dispatch_block_t)complition failure:(OMNErrorBlock)failureBlock;

- (void)confirmPhone:(NSString *)code complition:(OMNTokenBlock)complition failure:(OMNErrorBlock)failureBlock;

- (void)confirmPhoneResend:(dispatch_block_t)complition failure:(OMNErrorBlock)failureBlock;

+ (void)loginUsingPhone:(NSString *)phone code:(NSString *)code complition:(OMNTokenBlock)complition failure:(OMNErrorBlock)failureBlock;

+ (void)userWithToken:(NSString *)token user:(OMNUserBlock)userBlock failure:(OMNErrorBlock)failureBlock;

@end
