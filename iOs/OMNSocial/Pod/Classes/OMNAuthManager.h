//
//  GAuthManager.h
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

typedef NS_ENUM(NSInteger, SocialMediaType) {
  kSocialMediaTypeFirst = 0,
  kSocialMediaTypeGPlus = 0,
  kSocialMediaTypeVK,
  kSocialMediaTypeOK,
  kSocialMediaTypeFB,
  kSocialMediaTypeTwitter,
  kSocialMediaTypeMax,
};

#import "OMNSocialNetwork.h"

@interface OMNAuthManager : NSObject

+ (instancetype)manager;

//- (void)auth:(SocialMediaType)socialMediaType;

- (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

//- (void)getUserInfo:(GAuthorizerUserInfoBlock)userInfoBlock;

- (NSInteger)numberOfSocialNetworks;

- (OMNSocialNetwork *)socialNetworkAtIndex:(NSInteger)index;

@end
