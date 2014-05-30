//
//  OMNAuthorisation.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNUser;

typedef void(^OMNUserBlock)(OMNUser *user);

@interface OMNAuthorisation : NSObject

@property (nonatomic, copy, readonly) NSString *token;

+ (instancetype)authorisation;

- (void)registerUser:(OMNUserBlock)block;


@end
