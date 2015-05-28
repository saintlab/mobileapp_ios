//
//  OMNUser+network.h
//  omnom
//
//  Created by tea on 28.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"
#import <CoreLocation/CoreLocation.h>
#import "OMNError.h"
#import <PromiseKit.h>

@interface OMNUser (network)

+ (PMKPromise *)loginUsingPhone:(NSString *)phone code:(NSString *)code;
+ (PMKPromise *)userWithToken:(NSString *)token;

- (PMKPromise *)updateUserInfoAndImage;
- (PMKPromise *)updateUserInfo;

- (PMKPromise *)loadAvatar;

- (PMKPromise *)registerNewUser;

@end

@interface NSObject (omn_tokenResponse)

- (PMKPromise *)omn_decodeToken;

@end
