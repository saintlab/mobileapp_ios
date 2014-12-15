//
//  OMNAuthorisation.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"
#import "OMNError.h"

@interface OMNAuthorization : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong, readonly) OMNUser *user;
@property (nonatomic, copy, readonly) NSString *installId;

@property (nonatomic, copy) dispatch_block_t logoutCallback;

+ (instancetype)authorisation;

- (void)logout;

- (void)updateUserInfoWithUser:(OMNUser *)user;
- (void)checkTokenWithBlock:(void (^)(BOOL tokenIsValid))block;

- (BOOL)pushNotificationsRequested;
- (void)requestPushNotifications:(void(^)(BOOL))completion;
- (void)registerForRemoteNotificationsIfPossible;
- (void)registerForRemoteNotifications;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

@end

@interface NSDictionary (omn_tokenResponse)

- (void)decodeToken:(void (^)(NSString *token))completion failure:(void(^)(OMNError *))failureBlock;

@end
