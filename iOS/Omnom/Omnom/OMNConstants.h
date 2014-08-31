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

typedef void(^OMNDataBlock)(id data);

#define kUseStubData 0
#define kUseStubUser 0
#define kUseStubBeacon 0
#define kUseStubBeaconDecodeData 0
#define kUseStubOrdersData 0
#define kUseStubLogin 0
#define kUseGPBAcquiring 0
#define kForgetRequestPushNotification 1

#define kGreenColor ([UIColor colorWithRed:2 / 255. green:193 / 255. blue:100 / 255. alpha:1])

#define FuturaMediumFont(__FONTSIZE__) ([UIFont fontWithName:@"FuturaPT-Medium" size:__FONTSIZE__])
#define FuturaBookFont(__FONTSIZE__) ([UIFont fontWithName:@"FuturaPT-Book" size:__FONTSIZE__])
//Futura-OSF-Omnom-Regular
//Futura-OSF-Omnom-Medium
