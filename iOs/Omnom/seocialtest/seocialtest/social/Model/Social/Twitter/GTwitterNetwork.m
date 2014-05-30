//
//  GTwitterAuthorizer.m
//  seocialtest
//
//  Created by tea on 08.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GTwitterNetwork.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

@implementation GTwitterNetwork {
  ACAccountStore *_accountStore;
  ACAccountType *_twitterAccountType;
  ACAccount *_twitterAccount;
}

- (instancetype)init {
  self = [super init];
  if (self) {

    _accountStore = [[ACAccountStore alloc] init];
    _twitterAccountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
//    NSLog(@"%@", [_accountStore accountsWithAccountType:_twitterAccountType]);
    
    [[_accountStore accountsWithAccountType:_twitterAccountType] enumerateObjectsUsingBlock:^(ACAccount *account, NSUInteger idx, BOOL *stop) {
      
      NSLog(@"%@", account.username);
      NSLog(@"%@", account.credential.oauthToken);
      NSLog(@"%@", account.accountDescription);
      
    }];
    
    
  }
  return self;
}

- (NSString *)name {
  
  return NSLocalizedString(@"Twitter", nil);
  
}

- (void)authorize {

  __weak typeof(self)weakSelf = self;
  [_accountStore requestAccessToAccountsWithType:_twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
    if (granted) {
      
      [weakSelf handleSuccessLogin];
      
    }
    else {
      NSLog(@"requestAccessToAccountsWithType>%@", error);
    }
  }];
}

- (void)handleSuccessLogin {
  
  NSArray *accounts = [_accountStore accountsWithAccountType:_twitterAccountType];
  _twitterAccount = [accounts lastObject];
  
  [_accountStore saveAccount:_twitterAccount withCompletionHandler:^(BOOL success, NSError *error) {
    
    NSLog(@"saveAccount>%d, error>%@", success, error);
    
  }];
  
  ACAccountCredential *facebookCredential = [_twitterAccount credential];
  NSString *accessToken = [facebookCredential oauthToken];
  NSLog(@"twitter Access Token: %@", accessToken);
  NSLog(@"twitter account =%@", _twitterAccount);
  
}

- (void)getUserInfo:(GAuthorizerUserInfoBlock)userInfoBlock {
  // NSString *userID = [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"];
  
  NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
  NSDictionary *params = @{
                           @"screen_name" : _twitterAccount.username
                           };
  SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
  
  //  Attach an account to the request
  [request setAccount:_twitterAccount];
  
  //  Step 3:  Execute the request
  [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    
    NSError *jsonError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
    
    NSLog(@"performRequestWithHandler>%@", json);
    
  }];
  
  
  
}

@end
