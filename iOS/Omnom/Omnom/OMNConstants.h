//
//  OMNConstants.h
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

extern NSString * const kBaseUrlString;
extern NSString * const kAuthorizationUrlString;

extern NSString * const kBeaconUUIDString;

extern NSString * const CardIOAppToken;
extern NSString * const kMixpanelToken;

extern NSString * const kPushSoundName;

#define kUseStubBeacon 0
#define kUseStubBeaconDecodeData 0
#define kUseStubOrdersData 0

#define kGreenColor ([UIColor colorWithRed:2 / 255. green:193 / 255. blue:100 / 255. alpha:1])

#define FuturaMediumFont(__FONTSIZE__) ([UIFont fontWithName:@"FuturaPT-Medium" size:__FONTSIZE__])
#define FuturaBookFont(__FONTSIZE__) ([UIFont fontWithName:@"FuturaPT-Book" size:__FONTSIZE__])

@interface OMNConstants : NSObject

+ (NSString *)stringForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

+ (NSString *)baseUrlString;
+ (NSString *)authorizationUrlString;
+ (NSString *)beaconUUIDString;

+ (NSString *)cardIOAppToken;
+ (NSString *)mixpanelToken;

+ (NSString *)pushSoundName;

+ (BOOL)useStubBeacon;
+ (BOOL)useStubBeaconDecodeData;
+ (BOOL)useStubOrdersData;

@end
