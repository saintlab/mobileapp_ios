//
//  AFHTTPRequestOperationManager+omn_token.h
//  omnom
//
//  Created by tea on 29.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

extern NSString * const kAuthenticationTokenKey;

@interface AFHTTPRequestOperationManager (omn_token)

- (void)omn_setAuthenticationToken:(NSString *)token;

@end
