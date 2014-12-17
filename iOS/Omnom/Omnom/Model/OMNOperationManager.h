//
//  OMNOperationManager.h
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "OMNUtils.h"

typedef NS_ENUM(NSInteger, OMNReachableState) {
  kOMNReachableStateNoInternet = 0,
  kOMNReachableStateNoOmnom,
  kOMNReachableStateIsReachable,
};

@interface OMNOperationManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManager;

- (OMNReachableState)reachableState;

@end
