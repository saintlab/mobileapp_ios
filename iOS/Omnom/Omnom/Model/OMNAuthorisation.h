//
//  OMNAuthorisation.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNUser;

typedef void(^OMNUserBlock)(OMNUser *user);
typedef void(^OMNTokenBlock)(NSString *token);

@interface OMNAuthorisation : NSObject

@property (nonatomic, copy, readonly) NSString *token;

@property (nonatomic, copy, readonly) NSString *installId;

@property (nonatomic, strong) dispatch_block_t logoutCallback;

+ (instancetype)authorisation;

- (void)logout;

- (void)updateAuthenticationToken:(NSString *)token;

- (void)checkTokenWithBlock:(void (^)(BOOL tokenIsValid))block;

- (BOOL)pushNotificationsRequested;
- (void)requestPushNotifications:(void(^)(BOOL))completion;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

@end

@interface NSDictionary (omn_tokenResponse)

- (void)decodeToken:(OMNTokenBlock)complition failure:(void(^)(NSError *))failureBlock;

@end
