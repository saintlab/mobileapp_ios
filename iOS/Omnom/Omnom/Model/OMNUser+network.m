//
//  OMNUser+network.m
//  omnom
//
//  Created by tea on 28.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser+network.h"
#import "OMNAuthorizationManager.h"
#import "OMNAuthorisation.h"
#import "OMNAnalitics.h"
#import "OMNUtils.h"
#import "OMNImageManager.h"

@implementation OMNUser (network)

- (void)registerWithCompletion:(dispatch_block_t)completion failure:(void (^)(NSError *error))failureBlock {
  
  NSAssert(completion != nil, @"completion block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");
  
  if (0 == self.email.length ||
      0 == self.phone.length) {
    
    failureBlock([NSError errorWithDomain:NSStringFromClass(self.class)
                                     code:0
                                 userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"Введите почту и телефон", nil)}]);
    return;
  }
  
  NSMutableDictionary *parameters =
  [@{
     @"installId" : [OMNAuthorisation authorisation].installId,
     @"email" : self.email,
     @"phone" : self.phone,
     } mutableCopy];
  
  if (self.name.length) {
    parameters[@"name"] = self.name;
  }
  
  parameters[@"birth_date"] = self.birthDateString;
  
  [[OMNAuthorizationManager sharedManager] POST:@"register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject omn_isSuccessResponse]) {
      
      completion();
      
    }
    else {
      
      failureBlock([responseObject omn_internetError]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"USER_REGISTER_ERROR" jsonRequest:parameters responseOperation:operation];
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (void)verifyPhoneCode:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock {
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObject:self.phone forKey:@"phone"];
  if (code.length) {
    parameters[@"code"] = code;
  }
  
  [[OMNAuthorizationManager sharedManager] POST:@"/verify/phone" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject decodeToken:completion failure:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"USER_VERIFY_PHONE_ERROR" jsonRequest:parameters responseOperation:operation];
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (void)confirmPhone:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock {
  
  NSAssert(completion != nil, @"completion block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");
  
  NSDictionary *parameters =
  @{
    @"phone" : self.phone,
    @"code" : code,
    };
  
  [[OMNAuthorizationManager sharedManager] POST:@"/confirm/phone" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject decodeToken:completion failure:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"CONFIRM_PHONE_ERROR" jsonRequest:parameters responseOperation:operation];
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (void)confirmPhoneResend:(dispatch_block_t)completion failure:(void (^)(NSError *error))failureBlock {
  
  NSAssert(completion != nil, @"completion block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");
  
  NSDictionary *parameters =
  @{
    @"phone" : self.phone,
    };
  
  [[OMNAuthorizationManager sharedManager] POST:@"/confirm/phone/resend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"/confirm/phone/resend>%@", responseObject);
    completion();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"/confirm/phone/resend>%@", error);
    failureBlock([error omn_internetError]);
    
  }];
  
}

+ (void)loginUsingData:(NSString *)data code:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock {
  
  NSAssert(completion != nil, @"completion block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
  if (code.length) {
    parameters[@"code"] = code;
  }
  
  if (data) {
    parameters[@"phone"] = data;
  }
  else {
    
    failureBlock([NSError errorWithDomain:NSStringFromClass(self.class)
                                     code:0
                                 userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"Неправильная почта или телефон", nil)}]);
    return;
    
  }
  
  [self loginWithParameters:parameters completion:completion failure:failureBlock];
  
}

+ (void)recoverUsingData:(NSString *)data completion:(dispatch_block_t)completionBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
  if ([data omn_isValidPhone]) {
    parameters[@"phone"] = data;
  }
  
  [[OMNAuthorizationManager sharedManager] POST:@"recover" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject omn_isSuccessResponse]) {
      
      completionBlock();
      
    }
    else {
      
      failureBlock([responseObject omn_userError]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}

+ (void)loginWithParameters:(NSDictionary *)parameters completion:(void (^)(NSString *token))completion failure:(void (^)(NSError *error))failureBlock {
  
  [[OMNAuthorizationManager sharedManager] POST:@"authorization" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject decodeToken:completion failure:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"AUTHORIZATION_USER_ERROR" jsonRequest:parameters responseOperation:operation];
    failureBlock([error omn_internetError]);
    
  }];
  
}

+ (void)userWithToken:(NSString *)token user:(OMNUserBlock)userBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"token" : token,
    };
  
  [[OMNAuthorizationManager sharedManager] POST:@"/user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject omn_isSuccessResponse]) {
      
      OMNUser *user = [[OMNUser alloc] initWithJsonData:responseObject[@"user"]];
      userBlock(user);
      
    }
    else {
      
      [[OMNAnalitics analitics] logDebugEvent:@"GET_USER_ERROR" jsonRequest:parameters responseOperation:operation];
      failureBlock(nil);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"GET_USER_ERROR" jsonRequest:parameters responseOperation:operation];
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (void)updateCoordinates:(CLLocationCoordinate2D)coordinates {
  
  NSDictionary *parameters =
  @{
    @"coordinates" :
      @{
        @"longitude" : @(coordinates.longitude),
        @"latitude" : @(coordinates.latitude),
        },
    };
  
  [[OMNAuthorizationManager sharedManager] PUT:@"/user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    
    
  }];
  
}

- (void)loadImageWithCompletion:(dispatch_block_t)completion failure:(void (^)(NSError *error))failureBlock {
  
  if (nil == self.avatar) {
    failureBlock(nil);
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [[OMNImageManager manager] downloadImageWithURL:self.avatar completion:^(UIImage *image) {
    
    if (image) {
      
      weakSelf.image = image;
      completion();
      
    }
    else {
      
      failureBlock(nil);
      
    }
    
  }];
  
}

- (void)uploadImage:(UIImage *)image withCompletion:(dispatch_block_t)completion progress:(void (^)(CGFloat percent))progressBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSString *path = [NSString stringWithFormat:@"/user/avatar?token=%@", [OMNAuthorisation authorisation].token];
  AFHTTPRequestOperation *operation = [[OMNAuthorizationManager sharedManager] POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.9f) name:@"image" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
    
  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject omn_isSuccessResponse]) {
      
      completion();
      
    }
    else {
      
      failureBlock([responseObject omn_userError]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
  if (progressBlock) {
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {

      CGFloat progress = (CGFloat)totalBytesWritten/totalBytesExpectedToWrite;
      progressBlock(progress);
      
    }];
    
  }
  
}

- (void)updateUserInfoWithUserAndImage:(OMNUser *)user withCompletion:(dispatch_block_t)completion failure:(void(^)(NSError *))failureBlock {
  
  if (user.image) {
    
    __weak typeof(self)weakSelf = self;
    [self uploadImage:user.image withCompletion:^{
      
      [weakSelf updateUserInfoWithUser:user withCompletion:completion failure:failureBlock];
      
    } progress:^(CGFloat percent) {
      
      NSLog(@"%f", percent);
      
    } failure:^(NSError *error) {
      
      failureBlock([error omn_internetError]);
      
    }];
    
  }
  else {
    
    [self updateUserInfoWithUser:user withCompletion:completion failure:failureBlock];
    
  }
  
}

- (void)updateUserInfoWithUser:(OMNUser *)user withCompletion:(dispatch_block_t)completion failure:(void(^)(NSError *))failureBlock {
  
  if (nil == user) {
    failureBlock(nil);
    return;
  }
  
  NSString *token = [OMNAuthorisation authorisation].token;
  NSDictionary *parameters =
  @{
    @"token" : token,
    @"name" : user.name,
    @"email" : user.email,
    @"birth_date" : user.birthDateString,
    };
  
  [[OMNAuthorizationManager sharedManager] POST:@"/user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

    if ([responseObject omn_isSuccessResponse]) {
    
      OMNUser *user = [[OMNUser alloc] initWithJsonData:responseObject[@"user"]];
      [[OMNAuthorisation authorisation] updateUserInfoWithUser:user];
      completion();
      
    }
    else {
      
      failureBlock([responseObject omn_userError]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
  
}

- (void)recoverWithCompletion:(void (^)(NSURL *url))completion failure:(void (^)(NSError *error))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"token" : [OMNAuthorisation authorisation].token,
    };
  [[OMNAuthorizationManager sharedManager] GET:@"/recover" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject omn_isSuccessResponse]) {
      
      NSString *urlString = responseObject[@"link"];
      completion([NSURL URLWithString:urlString]);
      
    }
    else {
      
      failureBlock([responseObject omn_internetError]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (void)updateWithUser:(OMNUser *)user {
  
  self.id = user.id;
  self.name = user.name;
  self.email = user.email;
  self.phone = user.phone;
  self.status = user.status;
  self.created_at = user.created_at;
  self.birthDate = user.birthDate;

  if (nil == self.image ||
      ![self.avatar isEqualToString:user.avatar]) {
    
    [self loadImageWithCompletion:^{
      
    } failure:^(NSError *error) {
      
    }];
    
  }

  self.avatar = user.avatar;

  
}



@end

@implementation NSObject (omn_userError)

- (BOOL)omn_isSuccessResponse {
  
  if (NO == [self isKindOfClass:[NSDictionary class]]) {
    return NO;
  }
  NSDictionary *dictionary = (NSDictionary *)self;
  BOOL status = [dictionary[@"status"] isEqualToString:@"success"];
  return status;
  
}

- (NSError *)omn_userError {
  
  NSError *error = [OMNUtils errorFromCode:OMNErrorUnknoun];
  
  if (NO == [self isKindOfClass:[NSDictionary class]]) {
    return error;
  }
  
  NSDictionary *dictionary = (NSDictionary *)self;
  NSString *message = dictionary[@"error"][@"message"];
  if (message) {
    
    error = [NSError errorWithDomain:NSStringFromClass(self.class)
                                code:[dictionary[@"error"][@"code"] integerValue]
                            userInfo:@{NSLocalizedDescriptionKey : message}];
    
  }
  
  return error;
  
}

@end