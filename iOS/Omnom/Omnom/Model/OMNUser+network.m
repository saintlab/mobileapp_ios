//
//  OMNUser+network.m
//  omnom
//
//  Created by tea on 28.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser+network.h"
#import "OMNAuthorizationManager.h"
#import "OMNAuthorization.h"
#import "OMNAnalitics.h"
#import "OMNUtils.h"
#import "OMNImageManager.h"

@implementation OMNUser (network)

- (void)registerWithCompletion:(dispatch_block_t)completion failure:(void (^)(OMNError *error))failureBlock {
  
  NSAssert(completion != nil, @"completion block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");
  
  if (0 == self.email.length ||
      0 == self.phone.length) {
    failureBlock([OMNError userErrorFromCode:kOMNUserErrorCodeNoEmailAndPhone]);
    return;
  }
  
  NSMutableDictionary *parameters =
  [@{
     @"installId" : [OMNAuthorization authorization].installId,
     @"email" : self.email,
     @"phone" : self.phone,
     } mutableCopy];
  
  if (self.name.length) {
    parameters[@"name"] = self.name;
  }
  
  parameters[@"birth_date"] = self.birthDateString;
  
  [[OMNAuthorizationManager sharedManager] POST:@"/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject omn_isSuccessResponse]) {
      
      completion();
      
    }
    else {
      
      failureBlock([responseObject omn_userError]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"USER_REGISTER_ERROR" jsonRequest:parameters responseOperation:operation];
    failureBlock([operation omn_internetError]);
    
  }];
  
}

- (void)verifyPhoneCode:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(OMNError *error))failureBlock {
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObject:self.phone forKey:@"phone"];
  if (code.length) {
    parameters[@"code"] = code;
  }
  
  [[OMNAuthorizationManager sharedManager] POST:@"/verify/phone" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject decodeToken:completion failure:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"USER_VERIFY_PHONE_ERROR" jsonRequest:parameters responseOperation:operation];
    failureBlock([operation omn_internetError]);
    
  }];
  
}

- (void)confirmPhone:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(OMNError *error))failureBlock {
  
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
    failureBlock([operation omn_internetError]);
    
  }];
  
}

- (void)confirmPhoneResend:(dispatch_block_t)completion failure:(void (^)(OMNError *error))failureBlock {
  
  NSAssert(completion != nil, @"completion block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");
  
  NSDictionary *parameters =
  @{
    @"phone" : self.phone,
    };
  
  [[OMNAuthorizationManager sharedManager] POST:@"/confirm/phone/resend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    completion();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([operation omn_internetError]);
    
  }];
  
}

+ (void)loginUsingData:(NSString *)data code:(NSString *)code completion:(void (^)(NSString *token))completion failure:(void (^)(OMNError *error))failureBlock {
  
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
    
    failureBlock([OMNError userErrorFromCode:kOMNUserErrorCodeNoEmailAndPhone]);
    return;
    
  }
  
  [self loginWithParameters:parameters completion:completion failure:failureBlock];
  
}

+ (void)recoverUsingData:(NSString *)data completion:(dispatch_block_t)completionBlock failure:(void (^)(OMNError *error))failureBlock {
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
  if ([data omn_isValidPhone]) {
    parameters[@"phone"] = data;
  }
  
  [[OMNAuthorizationManager sharedManager] POST:@"/recover" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject omn_isSuccessResponse]) {
      
      completionBlock();
      
    }
    else {
      
      failureBlock([responseObject omn_userError]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([operation omn_internetError]);
    
  }];
  
}

+ (void)loginWithParameters:(NSDictionary *)parameters completion:(void (^)(NSString *token))completion failure:(void (^)(OMNError *error))failureBlock {
  
  [[OMNAuthorizationManager sharedManager] POST:@"/authorization" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject decodeToken:completion failure:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"AUTHORIZATION_USER_ERROR" jsonRequest:parameters responseOperation:operation];
    failureBlock([operation omn_internetError]);
    
  }];
  
}

+ (PMKPromise *)userWithToken:(NSString *)token {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    if (0 == token.length) {
      reject([OMNError omnomErrorFromCode:kOMNErrorNoUserToken]);
      return;
    }

    NSDictionary *parameters =
    @{
      @"token" : token,
      };

    [[OMNAuthorizationManager sharedManager] POST:@"/user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if ([responseObject omn_isSuccessResponse]) {
        
        OMNUser *user = [[OMNUser alloc] initWithJsonData:responseObject[@"user"]];
        [[OMNAnalitics analitics] setServerTimeStamp:[responseObject omn_timeStamp]];
        fulfill(user);
        
      }
      else {
        
        [[OMNAnalitics analitics] logDebugEvent:@"GET_USER_ERROR" jsonRequest:parameters responseOperation:operation];
        reject([OMNError omnomErrorFromCode:kOMNErrorNoUserToken]);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"GET_USER_ERROR" jsonRequest:parameters responseOperation:operation];
      reject([operation omn_internetError]);
      
    }];
    
  }];
  
}

- (void)logCoordinates:(CLLocationCoordinate2D)coordinates {
  
  NSDictionary *parameters =
  @{
    @"longitude" : @(coordinates.longitude),
    @"latitude" : @(coordinates.latitude),
    @"token" : [OMNAuthorization authorization].token,
    };
  
  [[OMNAuthorizationManager sharedManager] POST:@"/user/geo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (![responseObject omn_isSuccessResponse]) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"USER_COORDINATES_ERROR" jsonRequest:parameters jsonResponse:responseObject];
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"USER_COORDINATES_ERROR" jsonRequest:parameters responseOperation:operation];
    
  }];
  
}

- (void)loadImageWithCompletion:(dispatch_block_t)completion failure:(void (^)(OMNError *error))failureBlock {
  
  if (0 == self.avatar.length) {
    failureBlock(nil);
    return;
  }
  
  @weakify(self)
  [[OMNImageManager manager] downloadImageWithURL:self.avatar completion:^(UIImage *image) {
    
    if (image) {
      
      @strongify(self)
      self.image = image;
      completion();
      
    }
    else {
      
      failureBlock(nil);
      
    }
    
  }];
  
}

- (PMKPromise *)uploadAvatar:(UIImage *)image {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    NSString *path = [NSString stringWithFormat:@"/user/avatar?token=%@", [OMNAuthorization authorization].token];
    [[OMNAuthorizationManager sharedManager] POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      
      [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.9f) name:@"image" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
      
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if ([responseObject omn_isSuccessResponse]) {
        
        OMNUser *user = [[OMNUser alloc] initWithJsonData:responseObject[@"user"]];
        fulfill(user);
        
      }
      else {
        
        reject([responseObject omn_userError]);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([operation omn_internetError]);
      
    }];
    
  }];
  
}

- (PMKPromise *)updateUserInfoWithUserAndImage:(OMNUser *)user {
  
  if (user.image &&
      user.imageDidChanged) {
    
    return [self uploadAvatar:user.image].then(^(OMNUser *userWithAvatar) {
      
      user.avatar = userWithAvatar.avatar;
      return [self updateUserInfoWithUser:user];
      
    });

  }
  else {
    
    return [self updateUserInfoWithUser:user];
    
  }
  
}

- (PMKPromise *)updateUserInfoWithUser:(OMNUser *)user {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    if (!user) {
      reject([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
      return;
    }
    
    NSMutableDictionary *parameters =
    [@{
       @"token" : [OMNAuthorization authorization].token,
       @"name" : user.name,
       @"email" : user.email,
       @"birth_date" : user.birthDateString,
       } mutableCopy];
    
    if (user.avatar) {
      parameters[@"avatar"] = user.avatar;
    }
    
    
    [[OMNAuthorizationManager sharedManager] POST:@"/user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if ([responseObject omn_isSuccessResponse]) {
        
        OMNUser *newUser = [[OMNUser alloc] initWithJsonData:responseObject[@"user"]];
        [[OMNAuthorization authorization] updateUserInfoWithUser:newUser];
        fulfill(newUser);
        
      }
      else {
        
        reject([responseObject omn_userError]);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([operation omn_internetError]);
      
    }];
    
  }];
  
}

- (void)recoverWithCompletion:(void (^)(NSURL *url))completion failure:(void (^)(OMNError *error))failureBlock {
  
  NSDictionary *parameters =
  @{
    @"token" : [OMNAuthorization authorization].token,
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
    
    failureBlock([operation omn_internetError]);
    
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
  NSString *oldAvatar = self.avatar;
  self.avatar = user.avatar;

  if (self.avatar.length) {
    
    if (![oldAvatar isEqualToString:self.avatar]) {
      
      [self loadImageWithCompletion:^{} failure:^(NSError *error) {}];
      
    }
    
  }
  else {
    
    self.image = nil;
    
  }
  
}

@end
