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
    parameters[@"firstName"] = self.name;
    parameters[@"name"] = self.name;
  }
  
  if (self.birthDate) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:locale];
    [df setDateFormat:@"dd-MM-yyyy"];
    parameters[@"birthDate"] = [df stringFromDate:self.birthDate];
  }
  
  [[OMNAuthorizationManager sharedManager] POST:@"register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject[@"status"] isEqualToString:@"success"]) {
      completion();
    }
    else if ([responseObject isKindOfClass:[NSDictionary class]]) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"USER_REGISTER_ERROR" jsonRequest:parameters responseOperation:operation];
      NSDictionary *error = responseObject[@"error"];
      failureBlock([NSError errorWithDomain:NSStringFromClass(self.class) code:[error[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey : error[@"message"]}]);
      
    }
    else {
      failureBlock(nil);
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

+ (NSError *)errorFromResponse:(id)response {
  
  NSError *error = [OMNUtils errorFromCode:OMNErrorUnknoun];
  
  if (NO == [response isKindOfClass:[NSDictionary class]]) {
    return error;
  }
  
  NSString *message = response[@"error"][@"message"];
  if (message) {
    
    error = [NSError errorWithDomain:NSStringFromClass(self.class)
                                code:[response[@"error"][@"code"] integerValue]
                            userInfo:@{NSLocalizedDescriptionKey : message}];
    
  }
  
  return error;
  
}

+ (void)recoverUsingData:(NSString *)data completion:(dispatch_block_t)completionBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
  if ([data omn_isValidPhone]) {
    parameters[@"phone"] = data;
  }
  
  [[OMNAuthorizationManager sharedManager] POST:@"recover" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject[@"status"] isEqualToString:@"success"]) {
      completionBlock();
    }
    else {
      
      failureBlock([self errorFromResponse:responseObject]);
      
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
    
    if ([responseObject[@"status"] isEqualToString:@"success"]) {
      
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

@end
