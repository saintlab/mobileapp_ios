//
//  OMNAuthorisation.m
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthorisation.h"
#import "OMNOperationManager.h"
#import "OMNAuthorizationManager.h"
#import "OMNUser.h"
#import <SSKeychain.h>

static NSString * const kAccountName = @"test_account4";

@implementation OMNAuthorisation

+ (instancetype)authorisation {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _token = [SSKeychain passwordForService:@"token" account:kAccountName];
    
    if (_token) {
      [self updateAuthenticationToken];
    }
    else {
      
    }
    
    [self retriveToken];
    
  }
  return self;
}

- (NSString *)installId {
  
  NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
  //Check if we have UUID already
  NSString *retrieveuuid = [SSKeychain passwordForService:appName account:kAccountName];
  
  if (nil == retrieveuuid) {
    
    //Create new key for this app/device
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    retrieveuuid = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    //Save key to Keychain
    [SSKeychain setPassword:retrieveuuid forService:appName account:kAccountName];
  }
  
  return retrieveuuid;
}

- (void)updateAuthenticationToken {

  if (_token) {
    [[OMNOperationManager sharedManager].requestSerializer setValue:_token forHTTPHeaderField:@"x-authentication-token"];
  }

}

- (void)updateToken:(NSString *)newToken {
  
  _token = newToken;
  [SSKeychain setPassword:newToken forService:@"token" account:kAccountName];
  [self updateAuthenticationToken];
  
}

- (void)retriveToken {

  NSDictionary *parameters =
  @{
    @"installId" : self.installId
    };
  
  __weak typeof(self)weakSelf = self;
  [[OMNAuthorizationManager sharedManager] POST:@"authorization" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject decodeToken:^(NSString *token) {
      
      [weakSelf updateToken:token];
      
    } failure:^(NSError *error) {
      
    }];
    
    NSLog(@"responseObject>%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"error>%@", error);
    
  }];

}

- (void)confirmPhone:(NSString *)phone code:(NSString *)code {
  
  NSDictionary *parameters =
  @{
    @"phone" : phone,
    @"code" : code,
    };
  
  [[OMNAuthorizationManager sharedManager] POST:@"confirm/phone" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
}

@end

@implementation NSDictionary (omn_tokenResponse)

- (void)decodeToken:(OMNTokenBlock)complition failure:(OMNErrorBlock)failureBlock {
  
  if ([self[@"status"] isEqualToString:@"success"]) {
    
    complition(self[@"token"]);
    
  }
  else {
    
    NSString *errors = ([self[@"errors"] description].length) ? ([self[@"errors"] description]) : (@"");
    NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class)
                                         code:0
                                     userInfo:@{NSLocalizedDescriptionKey : errors}];
    failureBlock(error);
  }
  
}

@end