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
    
    return [resposne decodeToken];
    
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
       @"token" : [OMNAuthorization authorization].token,
       @"name" : self.name,
       @"email" : self.email,
       @"birth_date" : self.birthDateString,
       } mutableCopy];
    
    if (self.avatar) {
      parameters[@"avatar"] = self.avatar;
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

@end
