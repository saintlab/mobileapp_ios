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

static NSString * const kAccountName = @"test_account6";
NSString * const kTokenServiceName = @"token";

@implementation OMNAuthorisation {
  void(^_notificationRegisterCompletionBlock)(BOOL completion);
}

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

#if kForgetLoginInfo
#else
    NSString *token = [SSKeychain passwordForService:kTokenServiceName account:kAccountName];
    [self updateAuthenticationToken:token];
#endif
  }
  return self;
}

- (BOOL)pushNotificationsRequested {
#if kForgetRequestPushNotification
  return NO;
#else
  BOOL pushNotificationsRequested = [[SSKeychain passwordForService:@"pushNotificationsRequested" account:kAccountName] boolValue];
  return pushNotificationsRequested;
#endif
}

- (void)requestPushNotifications:(void(^)(BOOL))completion {
  
  if (NO == self.pushNotificationsRequested) {
    [SSKeychain setPassword:@"YES" forService:@"pushNotificationsRequested" account:kAccountName];
    _notificationRegisterCompletionBlock = [completion copy];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
  }
  else {
    completion(NO);
  }
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  _notificationRegisterCompletionBlock(YES);
  _notificationRegisterCompletionBlock = nil;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  _notificationRegisterCompletionBlock(NO);
  _notificationRegisterCompletionBlock = nil;
}

- (void)logout {
  [self updateAuthenticationToken:nil];
}

- (void)updateAuthenticationToken:(NSString *)token {

  _token = token;
  if (token) {
    [SSKeychain setPassword:token forService:kTokenServiceName account:kAccountName];
  }
  else {
    [SSKeychain deletePasswordForService:kTokenServiceName account:kAccountName];
  }
  
  [[OMNOperationManager sharedManager].requestSerializer setValue:token forHTTPHeaderField:@"x-authentication-token"];

  [self checkTokenWithBlock:^(BOOL tokenIsValid) {
  }];

}

- (void)checkTokenWithBlock:(void (^)(BOOL tokenIsValid))block {
  
  if (nil == self.token) {
    block(NO);
    return;
  }
  
  [OMNUser userWithToken:self.token user:^(OMNUser *user) {
    
    _user = user;
    block(YES);
    
  } failure:^(NSError *error) {
    
    NSLog(@"%@", error);
    block(NO);
    
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

@end

@implementation NSDictionary (omn_tokenResponse)

- (void)decodeToken:(OMNTokenBlock)completion failure:(void(^)(NSError *))failureBlock {
  
  if ([self[@"status"] isEqualToString:@"success"]) {
    
    completion(self[@"token"]);
    
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