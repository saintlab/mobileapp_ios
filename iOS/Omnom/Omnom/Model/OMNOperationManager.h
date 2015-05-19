//
//  OMNOperationManager.h
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "OMNUtils.h"

@interface OMNOperationManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManager;
+ (void)setupWithURL:(NSString *)url;

@end
