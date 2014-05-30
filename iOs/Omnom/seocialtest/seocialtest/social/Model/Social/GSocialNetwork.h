//
//  GAuthorizer.h
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

typedef void(^GAuthorizerUserInfoBlock)(NSString *name);
typedef void(^GAuthorizerImageBlock)(UIImage *image);

@interface GSocialNetwork : NSObject

@property (nonatomic, readonly) BOOL authorized;

@property (nonatomic, copy) NSString *accessToken;

+ (instancetype)network;

- (NSString *)name;

- (void)authorize:(dispatch_block_t)block;

- (void)logout;

- (BOOL)handleURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication
       annotation:(id)annotation;

- (void)getUserInfo:(GAuthorizerUserInfoBlock)userInfoBlock;

- (void)getProfileImage:(GAuthorizerImageBlock)imageBlock;

@end
