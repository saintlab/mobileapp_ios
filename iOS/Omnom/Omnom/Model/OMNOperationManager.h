//
//  OMNOperationManager.h
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface OMNOperationManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManager;

- (void)getReachableState:(void(^)(BOOL isReachable))isReachableBlock;

@end
