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
#import <Crashlytics/Crashlytics.h>
#import "OMNAnalitics.h"

static NSString * const kAccountName = @"test_account6";

@interface OMNAuthorisation ()

@property (nonatomic, strong) OMNUser *user;

@end

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

- (NSString *)tokenServiceName {
  
#if OMN_TEST
  NSString *tokenServiceName = @"test_token";
#else
  NSString *tokenServiceName = [OMNConstants baseUrlString];
#endif
  return tokenServiceName;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
#if OMN_TEST
    NSString *token = @"yeshackvofPigCob";
#else
    NSString *token = [SSKeychain passwordForService:[self tokenServiceName] account:kAccountName];
#endif
    [self updateAuthenticationToken:token withBlock:nil];
  }
  return self;
}

-(void)setUser:(OMNUser *)user {
  _user = user;
  [[OMNAnalitics analitics] setUser:user];
  [Crashlytics setUserEmail:user.email];
  [Crashlytics setUserName:user.id];
  [Crashlytics setUserIdentifier:[OMNConstants baseUrlString]];
}

- (BOOL)pushNotificationsRequested {
  BOOL pushNotificationsRequested = [[SSKeychain passwordForService:@"pushNotificationsRequested" account:kAccountName] boolValue];
  return pushNotificationsRequested;
}

#ifdef __IPHONE_8_0
- (UIUserNotificationSettings *)notificationSettings {
  UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
  declineAction.identifier = @"declineAction";
  declineAction.activationMode = UIUserNotificationActivationModeBackground;
  declineAction.title = NSLocalizedString(@"Отменить", nil);
  declineAction.destructive = YES;
  
  UIMutableUserNotificationAction *answerAction = [[UIMutableUserNotificationAction alloc] init];
  answerAction.identifier = @"answerAction";
  answerAction.activationMode = UIUserNotificationActivationModeBackground;
  answerAction.title = @"Ответить";
  
  UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
  category.identifier = @"incomingCall"; //category name to send in the payload
  [category setActions:@[answerAction,declineAction] forContext:UIUserNotificationActionContextDefault];
  [category setActions:@[answerAction,declineAction] forContext:UIUserNotificationActionContextMinimal];
  
  UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObjects:category,nil]];
  return settings;
}
#endif

- (void)requestPushNotifications:(void(^)(BOOL))completion {
  
  if (NO == self.pushNotificationsRequested) {
    [SSKeychain setPassword:@"YES" forService:@"pushNotificationsRequested" account:kAccountName];
    _notificationRegisterCompletionBlock = [completion copy];
    
    UIApplication *application = [UIApplication sharedApplication];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
      [application performSelector:@selector(registerForRemoteNotifications) withObject:nil];
#ifdef __IPHONE_8_0
      [[UIApplication sharedApplication] registerUserNotificationSettings:[self notificationSettings]];
#endif
      
#pragma clang diagnostic pop
    }
    else {
      [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
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
  self.user = nil;
  [self updateAuthenticationToken:nil withBlock:nil];
  if (self.logoutCallback) {
    self.logoutCallback();
  }
}

- (void)updateAuthenticationToken:(NSString *)token withBlock:(void (^)(BOOL tokenIsValid))block {

  if ([_token isEqualToString:token]) {
    return;
  }
  NSLog(@"updateAuthenticationToken>%@", token);

  _token = token;
  if (token) {
    [SSKeychain setPassword:token forService:[self tokenServiceName] account:kAccountName];
  }
  else {
    [SSKeychain deletePasswordForService:[self tokenServiceName] account:kAccountName];
  }
  
  [[OMNOperationManager sharedManager].requestSerializer setValue:token forHTTPHeaderField:@"x-authentication-token"];
  
  if (block) {
    [self checkTokenWithBlock:block];
  }

}

- (void)checkTokenWithBlock:(void (^)(BOOL tokenIsValid))block {
  
  if (nil == self.token) {
    block(NO);
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [OMNUser userWithToken:self.token user:^(OMNUser *user) {
    
    weakSelf.user = user;
    block(YES);
    
  } failure:^(NSError *error) {
    
    block(NO);
    
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

- (void)decodeToken:(void (^)(NSString *token))completion failure:(void(^)(NSError *))failureBlock {
  
  if ([self[@"status"] isEqualToString:@"success"]) {
    
    completion(self[@"token"]);
    
  }
  else {
    
    NSString *message = self[@"error"][@"message"];
    if (message) {
      NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class)
                                           code:[self[@"error"][@"code"] integerValue]
                                       userInfo:@{NSLocalizedDescriptionKey : message}];
      failureBlock(error);
    }
    else {
      failureBlock(nil);
    }

  }
  
}

@end