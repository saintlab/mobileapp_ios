//
//  OMNConstants.h
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

extern NSString * const kPushSoundName;

#define FuturaMediumFont(__FONTSIZE__) ([UIFont fontWithName:@"FuturaPT-Medium" size:__FONTSIZE__])
#define FuturaBookFont(__FONTSIZE__) ([UIFont fontWithName:@"FuturaPT-Book" size:__FONTSIZE__])
#define FuturaOSFOmnomMedium(__FONTSIZE__) ([UIFont fontWithName:@"Futura-OSF-Omnom-Medium" size:__FONTSIZE__])
#define FuturaOSFOmnomRegular(__FONTSIZE__) ([UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:__FONTSIZE__])
#define FuturaLSFOmnomRegular(__FONTSIZE__) ([UIFont fontWithName:@"Futura-LSF-Omnom-Regular" size:__FONTSIZE__])

#define CURRENT_VERSION ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define CURRENT_BUILD ([[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey])

@interface OMNConstants : NSObject

+ (void)setCustomConfigName:(NSString *)name;

+ (NSString *)stringForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

+ (NSString *)baseUrlString;
+ (NSString *)authorizationUrlString;
+ (NSString *)beaconUUIDString;

+ (NSString *)cardIOAppToken;
+ (NSString *)mixpanelToken;
+ (NSString *)crashlyticsAPIKey;

+ (NSString *)pushSoundName;

+ (BOOL)useStubBeacon;
+ (BOOL)useStubBeaconDecodeData;
+ (BOOL)useStubOrdersData;
+ (BOOL)useBackgroundNotifications;
+ (NSString *)mailRuConfig;

@end
