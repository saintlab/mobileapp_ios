//
//  GFBAuthorizer.m
//  seocialtest
//
//  Created by tea on 08.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GFBNetwork.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

static NSString * const kFBAppID = @"254655568054981";

@implementation GFBNetwork {
  ACAccountStore *_accountStore;
  ACAccountType *_FBaccountType;
  ACAccount *_facebookAccount;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _accountStore = [[ACAccountStore alloc] init];
    _FBaccountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
  }
  return self;
}

- (NSString *)name {
  return NSLocalizedString(@"Facebook", nil);
}

- (void)authorize {
  
  NSDictionary *options =
  @{
    ACFacebookAppIdKey : kFBAppID,
    ACFacebookPermissionsKey : @[@"email"]
    };
  
  __weak typeof(self)weakSelf = self;
  [_accountStore requestAccessToAccountsWithType:_FBaccountType options:options completion:^(BOOL granted, NSError *error) {
    
    if (granted) {
      
      [weakSelf handleSuccessLogin];

    }
    else {

      NSLog(@"error getting permission yupeeeeeee %@", error);

    }
    
  }];
  
}

- (void)handleSuccessLogin {

  NSArray *accounts = [_accountStore accountsWithAccountType:_FBaccountType];
  //it will always be the last object with single sign on
  
  NSLog(@"accounts>%@", accounts);
  
  _facebookAccount = [accounts lastObject];
  
  ACAccountCredential *facebookCredential = [_facebookAccount credential];
  NSString *accessToken = [facebookCredential oauthToken];
  NSLog(@"Facebook Access Token: %@", accessToken);
  NSLog(@"facebook account =%@", _facebookAccount);
  
//  [self get];
//  
//  
//  isFacebookAvailable = 1;
  
}

- (void)getUserInfo:(GAuthorizerUserInfoBlock)userInfoBlock {
  
  NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
  
  SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:nil];
  request.account = _facebookAccount;
  
  [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
    
    if(!error) {
      
      NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
      
      NSLog(@"Dictionary contains: %@", list );

      if([list objectForKey:@"error"] != nil) {
        [self attemptRenewCredentials];
      }
      
    }
    else {
      //handle error gracefully
      NSLog(@"error from get%@", error);
      //attempt to revalidate credentials
    }
    
  }];
  
}

- (void)attemptRenewCredentials {
  [_accountStore renewCredentialsForAccount:_facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
    if(!error)
    {
      switch (renewResult) {
        case ACAccountCredentialRenewResultRenewed: {
          NSLog(@"Good to go");
//          [self get];
          
        } break;
        case ACAccountCredentialRenewResultRejected: {
          NSLog(@"User declined permission");
        } break;
        case ACAccountCredentialRenewResultFailed: {
          NSLog(@"non-user-initiated cancel, you may attempt to retry");
        } break;
      }
      
    }
    else{
      //handle error gracefully
      NSLog(@"error from renew credentials%@",error);
    }
  }];
}

@end
