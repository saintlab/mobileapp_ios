//
//  OMNOperationManager.h
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "OMNUtils.h"

extern NSString * const kAuthenticationTokenKey;

@interface OMNOperationManager : AFHTTPRequestOperationManager

+ (void)setupWithURL:(NSString *)url headers:(NSDictionary *)headers;
+ (instancetype)sharedManager;
+ (void)setAuthenticationToken:(NSString *)token;

@end
