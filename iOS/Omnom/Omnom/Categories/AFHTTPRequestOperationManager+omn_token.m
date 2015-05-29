//
//  AFHTTPRequestOperationManager+omn_token.m
//  omnom
//
//  Created by tea on 29.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "AFHTTPRequestOperationManager+omn_token.h"

NSString * const kAuthenticationTokenKey = @"x-authentication-token";

@implementation AFHTTPRequestOperationManager (omn_token)

- (void)omn_setAuthenticationToken:(NSString *)token {
  [self.requestSerializer setValue:token forHTTPHeaderField:kAuthenticationTokenKey];
}

@end
