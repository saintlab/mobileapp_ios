//
//  OMNAuthorization.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"
#import "OMNError.h"
#import "OMNRestaurant.h"
#import <PromiseKit.h>

typedef void(^OMNAuthorizationBlock)(NSString *token, BOOL register);

@interface OMNAuthorization : NSObject

@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong, readonly) OMNUser *user;
@property (nonatomic, copy, readonly) NSString *installId;
@property (nonatomic, copy, readonly) NSString *supportPhone;

+ (instancetype)authorization;

- (BOOL)isAuthorized;
- (void)loadCachedUser;
- (void)updateUserInfoWithUser:(OMNUser *)user;
- (void)logout;
- (void)loadSupport;

- (PMKPromise *)setAuthenticationToken:(NSString *)token;
- (PMKPromise *)checkAuthenticationToken;

- (BOOL)pushNotificationsRequested;
- (void)requestPushNotifications:(void(^)(BOOL))completion;
- (void)registerForRemoteNotificationsIfPossible;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

@end
