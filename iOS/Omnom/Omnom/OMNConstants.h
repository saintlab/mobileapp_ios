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
extern NSString * const kTestFlightAppToken;
extern NSString * const kMixpanelToken;

extern NSString * const kPushSoundName;

extern NSString * const kRestaurantLogoUrl;
extern NSString * const kRestaurantBGUrl;

typedef void(^OMNErrorBlock)(NSError *error);
typedef void(^OMNDataBlock)(id data);

extern const NSTimeInterval kCircleFadeAnimationDuration;
extern const NSTimeInterval kCircleAnimationDuration;
extern const NSTimeInterval kOrderSlideAnimationDuration;

#define kUseStubData 1
#define kUseStubUser 0
#define kUseStubBeacon 1
#define kUseStubLogin 0
#define kUseGPBAcquiring 1

#define kGreenColor ([UIColor colorWithRed:2 / 255. green:193 / 255. blue:100 / 255. alpha:1])

#define kRestaurantColor ([UIColor colorWithRed:255 / 255. green:50 / 255. blue:50 / 255. alpha:1])

#define ALSRublFont(__FONTSIZE__) ([UIFont fontWithName:@"ALSRubl" size:__FONTSIZE__])
#define kPayButtonFont ALSRublFont(20.0f)

#define FuturaMediumFont(__FONTSIZE__) ([UIFont fontWithName:@"FuturaPT-Medium" size:__FONTSIZE__])
#define FuturaBookFont(__FONTSIZE__) ([UIFont fontWithName:@"FuturaPT-Book" size:__FONTSIZE__])
