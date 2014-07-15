//
//  GOKAuthorizer.m
//  seocialtest
//
//  Created by tea on 08.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOKNetwork.h"
#import "Odnoklassniki.h"

static NSString * const kOKAppID = @"1089100032";
static NSString * const kOKAppSecret = @"B5B8FAE52EDAC9C3DAFFD5FD";
static NSString * const kOKAppKey = @"CBAKFLOBEBABABABA";

@interface OMNOKNetwork ()
<OKSessionDelegate,
OKRequestDelegate>

@end

@implementation OMNOKNetwork {
  Odnoklassniki *_odnoklassniki;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _odnoklassniki = [[Odnoklassniki alloc] initWithAppId:kOKAppID andAppSecret:kOKAppSecret andAppKey:kOKAppKey andDelegate:self];
  }
  return self;
}

- (NSString *)name {
  return NSLocalizedString(@"Odnoklassniki", nil);
}

- (BOOL)authorized {
  
  return _odnoklassniki.isSessionValid;
  
}

- (void)authorize:(dispatch_block_t)block {
  
  [self willChangeValueForKey:NSStringFromSelector(@selector(authorized))];
  [_odnoklassniki authorize:@[]];
  
}

- (void)logout {
  
  [self willChangeValueForKey:NSStringFromSelector(@selector(authorized))];
  [_odnoklassniki logout];
  
}

- (BOOL)handleURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication
       annotation:(id)annotation {
  return [[OKSession activeSession] handleOpenURL:url];
}

- (void)getUserInfo:(GAuthorizerUserInfoBlock)userInfoBlock {
  
  OKRequest *newRequest = [Odnoklassniki requestWithMethodName:@"users.getCurrentUser" andParams:nil andHttpMethod:@"GET" andDelegate:self];
  [newRequest load];
  
}

#pragma mark - OKSessionDelegate

-(void)okDidLogin {
  
  [self didChangeValueForKey:NSStringFromSelector(@selector(authorized))];
  NSLog(@"okDidLogin %d", [NSThread isMainThread]);
}

-(void)okDidNotLogin:(BOOL)canceled {
  NSLog(@"okDidNotLoginWithError>%d", canceled);
}

-(void)okDidNotLoginWithError:(NSError *)error {
  NSLog(@"okDidNotLoginWithError>%@", error);
}

-(void)okDidExtendToken:(NSString *)accessToken {
  NSLog(@"okDidExtendToken>%@", accessToken);
}

-(void)okDidNotExtendToken:(NSError *)error {
  NSLog(@"okDidNotExtendToken>%@", error);
}

-(void)okDidLogout {
  
  [self didChangeValueForKey:NSStringFromSelector(@selector(authorized))];
  NSLog(@"okDidLogout");
}

#pragma mark - OKRequestDelegate

- (void)request:(OKRequest *)request didFailWithError:(NSError *)error {

  NSLog(@"requestdidFailWithError>%@", error);
  
}

- (void)request:(OKRequest *)request didLoad:(id)result {
  
  NSLog(@"requestdidLoad>%@", result);
  
}

@end
