//
//  OMNConstants.h
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNLaunch;
#import <PromiseKit.h>
#import "OMNConfig.h"

extern NSString * const kPushSoundName;

#define OMN_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define CURRENT_VERSION ([[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define CURRENT_BUILD ([[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey])

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

extern NSString * const OMNFacebookPageUrlString;
extern NSString * const OMNFacebookAppUrlString;

@interface OMNConstants : NSObject

+ (PMKPromise *)setupWithLaunch:(OMNLaunch *)launchOptions;
+ (void)setupNetworkManagers;

+ (NSString *)baseUrlString;
+ (NSString *)installID;

+ (NSString *)mixpanelToken;
+ (NSString *)mixpanelDebugToken;
+ (NSString *)mobileConfiguration;
+ (BOOL)disableOnEntrancePush;

+ (NSDictionary *)configWithName:(NSString *)name;

@end
