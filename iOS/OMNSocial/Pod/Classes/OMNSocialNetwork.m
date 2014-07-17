//
//  GAuthorizer.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSocialNetwork.h"
#import <SSKeychain/SSKeychain.h>

static NSString * const GSocialNetworkService = @"GSocialNetworkService";

@implementation OMNSocialNetwork {
  NSString *_accessToken;
}

+ (instancetype)network {
  return [[[self class] alloc] init];
}

- (NSString *)accessToken {
  
  if (nil == _accessToken) {
    _accessToken = [SSKeychain passwordForService:GSocialNetworkService account:self.g_account];
  }
  
  return _accessToken;
  
}

- (NSString *)g_account {
  return NSStringFromClass([self class]);
}

- (void)setAccessToken:(NSString *)accessToken {
  
  _accessToken = accessToken;
  
  if (0 == accessToken.length) {
    
    [SSKeychain deletePasswordForService:GSocialNetworkService account:self.g_account];
    
  }
  else {
    
    [SSKeychain setPassword:accessToken forService:GSocialNetworkService account:self.g_account];
    
  }
  
}

- (NSString *)name {
  return nil;
}

- (BOOL)authorized {
  return NO;
}

- (void)authorize:(dispatch_block_t)block {
  
  if (block) {
    block();
  }
  
}

- (void)logout {
  
}

- (BOOL)handleURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication
       annotation:(id)annotation {
  return NO;
}

- (void)getUserInfo:(GAuthorizerUserInfoBlock)userInfoBlock {
  
  if (userInfoBlock) {
    userInfoBlock(nil);
  }
  
}

- (void)getProfileImage:(GAuthorizerImageBlock)imageBlock {
  
  if (imageBlock) {
    imageBlock(nil);
  }
  
}

@end
