//
//  OMNAuthorizationManager.h
//  restaurants
//
//  Created by tea on 03.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface OMNAuthorizationManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManager;

@end
