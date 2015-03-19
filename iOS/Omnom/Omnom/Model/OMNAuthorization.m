//
//  OMNAuthorisation.m
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAnalitics.h"
#import "OMNAuthorization.h"
#import "OMNAuthorizationManager.h"
#import "OMNOperationManager.h"
#import "OMNUser.h"
#import "OMNUser+network.h"
#import <Crashlytics/Crashlytics.h>
#import <SSKeychain.h>
#import "NSData+omn_deviceToken.h"

static NSString * const kAuthorisationAccountName = @"test_account6";
static NSString * const kIOS7PushNotificationsRequestedKey = @"pushNotificationsRequested";
static NSString * const kIOS8PushNotificationsRequestedKey = @"kIOS8PushNotificationsRequestedKey";

@interface OMNAuthorization ()

@end

@implementation OMNAuthorization {
  void(^_userNotificationRegisterCompletionBlock)(BOOL completion);
  void(^_remoteNotificationRegisterCompletionBlock)(BOOL completion);
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
    _token = @"yeshackvofPigCob";
#else
    _token = [SSKeychain passwordForService:[self tokenServiceName] account:kAuthorisationAccountName];
#endif
    [self updateAuthenticationToken];
    
    _user = [[OMNUser alloc] init];

  }
  return self;
}

- (void)setup {
  
  @try {
    
    OMNUser *savedUser = [NSKeyedUnarchiver unarchiveObjectWithFile:[self savedUserPath]];
    [self updateUserInfoWithUser:savedUser];
    
  }
  @catch (NSException *exception) {}
  
}

- (NSString *)savedUserPath {
  
  NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  NSURL *baseURL = [NSURL URLWithString:[OMNConstants baseUrlString]];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-user.dat", baseURL.resourceSpecifier]];
  return path;
  
}

- (void)updateUserInfoWithUser:(OMNUser *)user {
  
  [NSKeyedArchiver archiveRootObject:user toFile:[self savedUserPath]];
  
  [self willChangeValueForKey:@"user"];
  
  [_user updateWithUser:user];
  
  [[OMNAnalitics analitics] setUser:user];
  
  [Crashlytics setUserEmail:user.email];
  [Crashlytics setUserName:user.id];
  [Crashlytics setUserIdentifier:[OMNConstants baseUrlString]];
  
  [self didChangeValueForKey:@"user"];
  
}


- (void)logout {
  
  [self unregisterDevice];
  
  [self updateUserInfoWithUser:nil];
  self.token = nil;
  if (self.logoutCallback) {
    
    self.logoutCallback();
    
  }
  
}

- (BOOL)pushNotificationsRequested {
  
#if LUNCH_2GIS
  return YES;
#endif
  
  BOOL pushNotificationsRequested = NO;
  if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    
    pushNotificationsRequested = [[SSKeychain passwordForService:kIOS8PushNotificationsRequestedKey account:kAuthorisationAccountName] boolValue];
    
  }
  else {
    
    pushNotificationsRequested = [[SSKeychain passwordForService:kIOS7PushNotificationsRequestedKey account:kAuthorisationAccountName] boolValue];
    
  }

  return pushNotificationsRequested;
  
}

- (UIUserNotificationSettings *)notificationSettings {
//  UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
//  declineAction.identifier = @"declineAction";
//  declineAction.activationMode = UIUserNotificationActivationModeBackground;
//  declineAction.title = NSLocalizedString(@"Отменить", nil);
//  declineAction.destructive = YES;
//  
//  UIMutableUserNotificationAction *answerAction = [[UIMutableUserNotificationAction alloc] init];
//  answerAction.identifier = @"answerAction";
//  answerAction.activationMode = UIUserNotificationActivationModeBackground;
//  answerAction.title = @"Ответить";
//  
//  UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
//  category.identifier = @"incomingCall"; //category name to send in the payload
//  [category setActions:@[answerAction,declineAction] forContext:UIUserNotificationActionContextDefault];
//  [category setActions:@[answerAction,declineAction] forContext:UIUserNotificationActionContextMinimal];
  
  UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObjects:nil]];
  return settings;
}

- (void)requestPushNotifications:(void(^)(BOOL))completion {
  
  if (self.pushNotificationsRequested) {
    
    completion(YES);
    return;
    
  }
  
  UIApplication *application = [UIApplication sharedApplication];
  
  if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    
    [SSKeychain setPassword:@"YES" forService:kIOS8PushNotificationsRequestedKey account:kAuthorisationAccountName];
    _userNotificationRegisterCompletionBlock = [completion copy];
    
  }
  else {
    
    [SSKeychain setPassword:@"YES" forService:kIOS7PushNotificationsRequestedKey account:kAuthorisationAccountName];
    _remoteNotificationRegisterCompletionBlock = [completion copy];
    
  }
  
  //anyway we need to register for remote notifications to obtain device token
  [self registerForRemoteNotificationsIfPossible];
  
}

- (void)registerForRemoteNotificationsIfPossible {
  
  if (self.pushNotificationsRequested) {
    
    UIApplication *application = [UIApplication sharedApplication];
    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
      
      [application registerForRemoteNotifications];
      
    }
    else {
      
      [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
      
    }
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
      
      [application registerUserNotificationSettings:[self notificationSettings]];
      
    }
    
  }
  
}

- (void)registerDeviceIfPossible {
  
  if (self.deviceToken &&
      self.token) {
    
    NSDictionary *parameters =
    @{
      @"push_token" : [self.deviceToken omn_deviceTokenString],
      };
    [[OMNOperationManager sharedManager] POST:@"/notifier/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"NOTIFIER_REGISTER" jsonRequest:parameters jsonResponse:responseObject];
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_REGISTER_NOTIFIER" jsonRequest:parameters responseOperation:operation];
      
    }];
    
  }
  
}

- (void)unregisterDevice {
  
  [[OMNOperationManager sharedManager] POST:@"/notifier/unregister" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
  }];
  
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {

  if (_userNotificationRegisterCompletionBlock) {
    _userNotificationRegisterCompletionBlock(YES);
    _userNotificationRegisterCompletionBlock = nil;
  }
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  [[OMNAnalitics analitics] logDebugEvent:@"didRegisterForRemoteNotificationsWithDeviceToken" jsonRequest:[deviceToken description] jsonResponse:nil];
  self.deviceToken = deviceToken;
  [self registerDeviceIfPossible];
  
  if (_remoteNotificationRegisterCompletionBlock) {
    _remoteNotificationRegisterCompletionBlock(YES);
    _remoteNotificationRegisterCompletionBlock = nil;
  }
  
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  
  [[OMNAnalitics analitics] logDebugEvent:@"didFailToRegisterForRemoteNotificationsWithError" jsonRequest:[NSString stringWithFormat:@"%@", error] jsonResponse:nil];
  if (_remoteNotificationRegisterCompletionBlock) {
    _remoteNotificationRegisterCompletionBlock(NO);
    _remoteNotificationRegisterCompletionBlock = nil;
  }
  
}

- (void)setToken:(NSString *)token {
  
  _token = token;
  if (token) {
    
    [SSKeychain setPassword:token forService:[self tokenServiceName] account:kAuthorisationAccountName];
    
  }
  else {
    
    [SSKeychain deletePasswordForService:[self tokenServiceName] account:kAuthorisationAccountName];
    
  }
  [self updateAuthenticationToken];
  
}

- (void)updateAuthenticationToken {
  
  [[OMNOperationManager sharedManager].requestSerializer setValue:self.token forHTTPHeaderField:@"x-authentication-token"];
  [self registerDeviceIfPossible];
  
}

- (void)checkUserWithBlock:(void (^)(OMNUser *user))userBlock failure:(void (^)(OMNError *error))failureBlock {
  
  if (0 == self.token.length) {
    userBlock(nil);
    return;
  }
  
  @weakify(self)
  [OMNUser userWithToken:self.token user:^(OMNUser *user) {
    
    @strongify(self)
    [self updateUserInfoWithUser:user];
    
    if (!user) {
      
      self.token = nil;
      
    }
    userBlock(user);
    
  } failure:^(OMNError *error) {
    
    failureBlock(error);
    
  }];
  
}

- (NSString *)installId {
  
  NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
  //Check if we have UUID already
  NSString *retrieveuuid = [SSKeychain passwordForService:appName account:kAuthorisationAccountName];
  DDLogDebug(@"installId>%@", retrieveuuid);
  if (nil == retrieveuuid) {
    
    //Create new key for this app/device
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    retrieveuuid = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    
    //Save key to Keychain
    [SSKeychain setPassword:retrieveuuid forService:appName account:kAuthorisationAccountName];
  }
  
  return retrieveuuid;
}

@end

@implementation NSDictionary (omn_tokenResponse)

- (void)decodeToken:(void (^)(NSString *token))completion failure:(void(^)(OMNError *))failureBlock {
  
  if ([self[@"status"] isEqualToString:@"success"]) {
    
    completion(self[@"token"]);
    
  }
  else {
    
    OMNError *error = nil;
    NSString *message = self[@"error"][@"message"];
    if (message) {
      
      error = [OMNError errorWithDomain:OMNUserErrorDomain
                                   code:[self[@"error"][@"code"] integerValue]
                               userInfo:@{NSLocalizedDescriptionKey : message}];
      
      
    }
    else {
      
      error = [OMNError userErrorFromCode:kOMNUserErrorCodeUnknoun];
      
    }
    
    failureBlock(error);
    
  }
  
}

@end