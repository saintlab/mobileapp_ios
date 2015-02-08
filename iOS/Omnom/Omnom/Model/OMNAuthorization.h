//
//  OMNAuthorisation.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"
#import "OMNError.h"
#import "OMNRestaurant.h"

@interface OMNAuthorization : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong, readonly) OMNUser *user;

@property (nonatomic, copy, readonly) NSString *installId;

@property (nonatomic, copy) dispatch_block_t logoutCallback;

+ (instancetype)authorisation;

- (void)setup;
- (void)updateUserInfoWithUser:(OMNUser *)user;
- (void)logout;

- (void)checkUserWithBlock:(void (^)(OMNUser *user))userBlock failure:(void (^)(OMNError *error))failureBlock;

- (BOOL)pushNotificationsRequested;
- (void)requestPushNotifications:(void(^)(BOOL))completion;
- (void)registerForRemoteNotificationsIfPossible;
//- (void)registerForRemoteNotifications;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

@end

@interface NSDictionary (omn_tokenResponse)

- (void)decodeToken:(void (^)(NSString *token))completion failure:(void(^)(OMNError *))failureBlock;

@end
