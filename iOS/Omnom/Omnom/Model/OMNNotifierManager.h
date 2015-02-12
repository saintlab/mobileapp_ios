//
//  OMNNotifierManager.h
//  omnom
//
//  Created by tea on 18.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

//https://github.com/saintlab/mobileapp_ios/issues/77

#import <AFNetworking/AFNetworking.h>

@interface OMNNotifierManager : AFHTTPRequestOperationManager

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) NSData *deviceToken;

+ (instancetype)sharedManager;

@end
