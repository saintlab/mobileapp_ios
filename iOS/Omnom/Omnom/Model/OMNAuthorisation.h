//
//  OMNAuthorisation.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"

@interface OMNAuthorisation : NSObject

@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, strong, readonly) OMNUser *user;
@property (nonatomic, copy, readonly) NSString *installId;

@property (nonatomic, copy) dispatch_block_t logoutCallback;

+ (instancetype)authorisation;

- (void)logout;

- (void)updateAuthenticationToken:(NSString *)token withBlock:(void (^)(BOOL tokenIsValid))block;;

- (void)checkTokenWithBlock:(void (^)(BOOL tokenIsValid))block;

- (BOOL)pushNotificationsRequested;
- (void)requestPushNotifications:(void(^)(BOOL))completion;
- (void)registerForRemoteNotifications;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

@end

@interface NSDictionary (omn_tokenResponse)

- (void)decodeToken:(void (^)(NSString *token))completion failure:(void(^)(NSError *))failureBlock;

@end
