//
//  GVKAuthorizer.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GVKNetwork.h"
#import <VKSdk.h>

static NSString * const kVKAppID = @"4350297";

@interface GVKNetwork ()
<VKSdkDelegate>

@end

@implementation GVKNetwork {
  NSArray *_scope;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _scope = @[VK_PER_STATS];
    
    [VKSdk wakeUpSession];
    [VKSdk initializeWithDelegate:self andAppId:kVKAppID];
    
  }
  return self;
}

- (BOOL)authorized {
  return [VKSdk isLoggedIn];
}

- (NSString *)name {
  return NSLocalizedString(@"VK", nil);
}

- (NSString *)accessToken {
  
  return [VKSdk getAccessToken].accessToken;
  
}

- (void)authorize:(dispatch_block_t)block {

  if (self.authorized) {
    
    if(block) {
      block();
    }
    
  }
  else {
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(authorized))];
    [VKSdk authorize:_scope revokeAccess:NO forceOAuth:NO];
    
  }
  
}

- (void)logout {
 
  [self willChangeValueForKey:NSStringFromSelector(@selector(authorized))];
  [VKSdk forceLogout];
  [self didChangeValueForKey:NSStringFromSelector(@selector(authorized))];
  
}

- (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  return [VKSdk processOpenURL:url fromApplication:sourceApplication];
  
}

- (void)getUserInfo:(GAuthorizerUserInfoBlock)userInfoBlock {
  
  VKRequest *request = [[VKApi users] get:@{@"fields" : @"sex, bdate, city, country, photo_50, photo_100, photo_200_orig, photo_200, photo_400_orig, photo_max, photo_max_orig, online, online_mobile, lists, domain, has_mobile, contacts, connections, site, education, universities, schools, can_post, can_see_all_posts, can_see_audio, can_write_private_message, status, last_seen, common_count, relation, relatives, counters,screen_name,timezone"}];
	[request executeWithResultBlock: ^(VKResponse *response) {
    NSLog(@"Result: %@", response);
	} errorBlock: ^(NSError *error) {
    NSLog(@"Error: %@", error);
	}];
  
}

- (void)getProfileImage:(GAuthorizerImageBlock)imageBlock {
  
  dispatch_queue_t backgroundQueue =
  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  
  [[[VKApi users] get:@{@"fields" : @"photo_100, photo_max"}] executeWithResultBlock:^(VKResponse *response) {
    
    NSString *imageURLString = [response.json firstObject][@"photo_100"];
    
    dispatch_async(backgroundQueue, ^{
      NSData *avatarData = nil;
      if (imageURLString) {
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        avatarData = [NSData dataWithContentsOfURL:imageURL];
      }
      
      if (avatarData) {
        dispatch_async(dispatch_get_main_queue(), ^{
          
          imageBlock([UIImage imageWithData:avatarData]);
          
        });
      }
    });
    
    NSLog(@"%@", response);
    
  } errorBlock:^(NSError *error) {
    
    imageBlock(nil);
    
  }];

  
}

#pragma mark - VKSdkDelegate

- (void)vkSdkReceivedNewToken:(VKAccessToken*) newToken {
  
  [self didChangeValueForKey:NSStringFromSelector(@selector(authorized))];
  NSLog(@"vkSdkReceivedNewToken>%@", newToken.accessToken);
  
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
  NSLog(@"vkSdkUserDeniedAccess>%@", authorizationError);
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
  
  [VKSdk authorize:_scope revokeAccess:YES];
  NSLog(@"vkSdkTokenHasExpired>%@", expiredToken);
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
  NSLog(@"vkSdkNeedCaptchaEnter>%@", captchaError);
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
  NSLog(@"vkSdkShouldPresentViewController>%@", controller);
}

@end
