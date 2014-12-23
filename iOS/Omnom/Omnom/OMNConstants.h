//
//  OMNConstants.h
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

extern NSString * const kPushSoundName;

#define FuturaOSFOmnomMedium(__FONTSIZE__) ([UIFont fontWithName:@"Futura-OSF-Omnom-Medium" size:__FONTSIZE__])
#define FuturaOSFOmnomRegular(__FONTSIZE__) ([UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:__FONTSIZE__])
#define FuturaLSFOmnomLERegular(__FONTSIZE__) ([UIFont fontWithName:@"Futura-LSF-Omnom-LE-Regular" size:__FONTSIZE__])

#define CURRENT_VERSION ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define CURRENT_BUILD ([[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey])

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

extern const CGFloat kOrderTableFooterHeight;

extern NSString * const OMNFacebookPageUrlString;

@interface OMNConstants : NSObject

+ (void)setupWithLaunchOptions:(NSDictionary *)launchOptions completion:(dispatch_block_t)completionBlock;
+ (NSString *)stringForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

+ (NSString *)baseUrlString;
+ (NSString *)authorizationUrlString;
+ (NSString *)notifierUrlString;

+ (NSString *)mixpanelToken;
+ (NSString *)mixpanelDebugToken;
+ (NSString *)crashlyticsAPIKey;

+ (NSString *)pushSoundName;

@end
