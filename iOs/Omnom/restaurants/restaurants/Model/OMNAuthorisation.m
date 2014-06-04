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
#import <SSKeychain.h>
#import "OMNUser.h"

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
    
    _token = [SSKeychain passwordForService:@"token" account:@"user"];
    
    if (_token) {
      [self updateAuthenticationToken];
    }
    else {
      [self retriveToken];
    }
    
  }
  return self;
}

- (NSString *)installId {
  
  NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
  
  //Check if we have UUID already
  NSString *retrieveuuid = [SSKeychain passwordForService:appName account:@"user"];
  
  if (nil == retrieveuuid) {
    
    //Create new key for this app/device
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    retrieveuuid = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    //Save key to Keychain
    [SSKeychain setPassword:retrieveuuid forService:appName account:@"user"];
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
  [SSKeychain setPassword:newToken forService:@"token" account:@"account"];
  [self updateAuthenticationToken];
  
}

- (void)retriveToken {

  __weak typeof(self)weakSelf = self;
  [[OMNAuthorizationManager sharedManager] POST:@"authorization" parameters:@{@"installId" : self.installId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"token"]) {
      [weakSelf updateToken:responseObject[@"token"]];
    }
    
    NSLog(@"responseObject>%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"error>%@", error);
    
  }];

}

- (void)registerUser:(OMNUserBlock)block {
  
  NSDictionary *parameters =
  @{
    @"installId" : self.installId,
    @"firstName" : @"Александр",
    @"lastName" : @"Белоглазов",
    @"nickName" : @"sibgeek",
    @"email" : @"teanet@mail.ru",
    @"phone" : @"+79833087335",
    @"password" : @"qwerty",
    @"confirmPassword" : @"qwerty",
    };

  [[OMNAuthorizationManager sharedManager] POST:@"register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    OMNUser *user = [[OMNUser alloc] initWithData:responseObject];
    NSLog(@"%@", user);
    NSLog(@"responseObject>%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    NSLog(@"error>%@", error);
    
  }];
  
}

- (void)confirm:(NSString *)code {
//  'phone': '+79137420445',
//  'code': '5407'
//  [[OMNOperationManager sharedManager] POST:<#(NSString *)#> parameters:<#(id)#> success:<#^(AFHTTPRequestOperation *operation, id responseObject)success#> failure:<#^(AFHTTPRequestOperation *operation, NSError *error)failure#>]
//  
//  /confirm/phone
}

@end
