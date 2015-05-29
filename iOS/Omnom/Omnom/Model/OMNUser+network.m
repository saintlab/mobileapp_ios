//
//  OMNUser+network.m
//  omnom
//
//  Created by tea on 28.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser+network.h"
#import "OMNAuthorizationManager.h"
#import "OMNAnalitics.h"
#import "OMNUtils.h"
#import "OMNImageManager.h"
#import "UIImage+omn_network.h"

@implementation OMNUser (network)

+ (PMKPromise *)loginUsingPhone:(NSString *)phone code:(NSString *)code {
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
  if (phone) {
    parameters[@"phone"] = phone;
  }
  else {
    
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
      
      reject([OMNError userErrorFromCode:kOMNUserErrorCodeNoEmailAndPhone]);
      
    }];
    
  }

  if (code.length) {
    parameters[@"code"] = code;
  }
  
  return [self loginWithParameters:parameters].then(^(NSDictionary *resposne) {
    
    return [resposne omn_decodeToken];
    
  });
  
}

+ (PMKPromise *)loginWithParameters:(NSDictionary *)parameters {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNAuthorizationManager sharedManager] POST:@"/authorization" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      fulfill(responseObject);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"AUTHORIZATION_USER_ERROR" jsonRequest:parameters responseOperation:operation];
      reject([operation omn_internetError]);
      
    }];

  }];
  
}

+ (PMKPromise *)userWithToken:(NSString *)token {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    if (0 == token.length) {
      reject([OMNError omnomErrorFromCode:kOMNErrorInvalidUserToken]);
      return;
    }

    NSDictionary *parameters =
    @{
      @"token" : token,
      };

    [[OMNAuthorizationManager sharedManager] POST:@"/user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if ([responseObject omn_isSuccessResponse]) {
        
        OMNUser *user = [[OMNUser alloc] initWithJsonData:responseObject[@"user"] token:token];
        fulfill(user);
        
      }
      else {
        
        [[OMNAnalitics analitics] logDebugEvent:@"GET_USER_ERROR" jsonRequest:parameters responseOperation:operation];
        reject([OMNError omnomErrorFromCode:kOMNErrorInvalidUserToken]);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"GET_USER_ERROR" jsonRequest:parameters responseOperation:operation];
      reject([operation omn_internetError]);
      
    }];
    
  }];
  
}

- (PMKPromise *)loadAvatar {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    if (0 == self.avatar.length) {
      reject([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
      return;
    }
    
    @weakify(self)
    [[OMNImageManager manager] downloadImageWithURL:self.avatar completion:^(UIImage *image) {
      
      if (image) {
        
        @strongify(self)
        self.image = image;
        fulfill(image);
        
      }
      else {
        
        reject([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
        
      }
      
    }];

  }];
  
}

- (PMKPromise *)uploadUserImageIfNeeded {
  
  if (self.image &&
      self.imageDidChanged) {
    
    return [self.image omn_upload];
    
  }
  else {
    
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
      
      fulfill(self.avatar);
      
    }];
    
  }
  
}

- (PMKPromise *)updateUserInfoAndImage {
  
  return [self uploadUserImageIfNeeded].then(^(NSString *avatar) {
    
    self.avatar = avatar;
    return [self updateUserInfo];
    
  });
  
}

- (PMKPromise *)updateUserInfo {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    NSMutableDictionary *parameters =
    [@{
       @"token" : self.token,
       @"name" : self.name,
       @"email" : self.email,
       @"birth_date" : self.birthDateString,
       } mutableCopy];
    
    if (self.avatar) {
      parameters[@"avatar"] = self.avatar;
    }
    
    [[OMNAuthorizationManager sharedManager] POST:@"/user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if ([responseObject omn_isSuccessResponse]) {
        
        OMNUser *newUser = [[OMNUser alloc] initWithJsonData:responseObject[@"user"] token:self.token];
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

- (PMKPromise *)registerNewUser {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    NSMutableDictionary *parameters =
    [@{
       @"token" : self.token,
       @"name" : self.name,
       @"email" : self.email,
       @"birth_date" : self.birthDateString,
       } mutableCopy];
    
    if (self.avatar) {
      parameters[@"avatar"] = self.avatar;
    }
    
    [[OMNAuthorizationManager sharedManager] POST:@"/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if ([responseObject omn_isSuccessResponse]) {
        
        OMNUser *newUser = [[OMNUser alloc] initWithJsonData:responseObject[@"user"] token:self.token];
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

@end

@implementation NSObject (omn_tokenResponse)

- (PMKPromise *)omn_decodeToken {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {

    if (![self isKindOfClass:[NSDictionary class]]) {
      reject([OMNError userErrorFromCode:kOMNUserErrorCodeUnknoun]);
      return;
    }
    
    NSDictionary *response = (NSDictionary *)self;
    
    if ([response[@"status"] isEqualToString:@"success"]) {
      
      fulfill(response[@"token"]);
      
    }
    else {
      
      OMNError *error = nil;
      NSString *message = response[@"error"][@"message"];
      if (message) {
        
        error = [OMNError errorWithDomain:OMNUserErrorDomain
                                     code:[response[@"error"][@"code"] integerValue]
                                 userInfo:@{NSLocalizedDescriptionKey : message}];
        
        
      }
      else {
        
        error = [OMNError userErrorFromCode:kOMNUserErrorCodeUnknoun];
        
      }
      
      reject(error);
      
    }
    
  }];
  
}

@end