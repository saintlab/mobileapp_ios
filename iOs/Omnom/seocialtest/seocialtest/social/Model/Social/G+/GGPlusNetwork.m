//
//  GGPlusAuthorizer.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GGPlusNetwork.h"
#import <GooglePlus.h>
#import <GTLPlusConstants.h>
#import <GTLServicePlus.h>
#import <GTLQueryPlus.h>
#import <GTLPlusPerson.h>

static NSString * const kClientID = @"929045501304-1edj5k5c7mq9ho35cicnt5d6dqjs4lvj.apps.googleusercontent.com";

@interface GGPlusNetwork()
<GPPSignInDelegate>

@end

@implementation GGPlusNetwork {
  GPPSignIn *_signIn;
  dispatch_block_t _authBlock;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _signIn = [GPPSignIn sharedInstance];
    _signIn.scopes = @[kGTLAuthScopePlusLogin,
                       kGTLAuthScopePlusMe];
    _signIn.shouldFetchGooglePlusUser = YES;
    _signIn.shouldFetchGoogleUserEmail = YES;
    _signIn.clientID = kClientID;
    _signIn.delegate = self;
    
    [_signIn trySilentAuthentication];

  }
  return self;
}

- (NSString *)name {
  return NSLocalizedString(@"Google+", nil);
}

- (void)authorize:(dispatch_block_t)block {
  
  _authBlock = block;
  
  [self willChangeValueForKey:NSStringFromSelector(@selector(authorized))];
  [_signIn authenticate];
  
}

- (BOOL)authorized {
  
  return (_signIn.authentication != nil);
  
}

- (void)logout {
  
  [self willChangeValueForKey:NSStringFromSelector(@selector(authorized))];
  [_signIn disconnect];
  
}

- (BOOL)handleURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication
       annotation:(id)annotation {
  return [_signIn handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)getProfileImage:(GAuthorizerImageBlock)imageBlock {

  dispatch_queue_t backgroundQueue =
  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

  NSString *imageURLString = _signIn.googlePlusUser.image.url;
  
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
  
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
  
  NSLog(@"finishedWithAuth %d", [NSThread isMainThread]);
  [self didChangeValueForKey:NSStringFromSelector(@selector(authorized))];

  if (_authBlock) {
    _authBlock();
  }
  
  
  NSLog(@"%@", _signIn.authentication);
  
  NSLog(@"finishedWithAuth>%@ %@", auth, error);
  
}

- (void)didDisconnectWithError:(NSError *)error {
  
  [self didChangeValueForKey:NSStringFromSelector(@selector(authorized))];

  NSLog(@"didDisconnectWithError>%@", error);
  
}



@end
