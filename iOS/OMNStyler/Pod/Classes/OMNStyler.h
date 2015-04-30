//
//  OMNStyler.h
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStyle.h"

#define kUseRemoteTimings 0
#define FuturaOSFOmnomMedium(__FONTSIZE__) ([UIFont fontWithName:@"Futura-OSF-Omnom-Medium" size:__FONTSIZE__])
#define FuturaOSFOmnomRegular(__FONTSIZE__) ([UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:__FONTSIZE__])
#define FuturaLSFOmnomLERegular(__FONTSIZE__) ([UIFont fontWithName:@"Futura-LSF-Omnom-LE-Regular" size:__FONTSIZE__])

#define PRICE_BUTTON_FONT (FuturaLSFOmnomLERegular(20.0f))

@interface OMNStyler : NSObject

+ (instancetype)styler;

+ (CGFloat)leftOffset;
+ (CGFloat)bottomToolbarHeight;
+ (CGFloat)orderTableFooterHeight;

+ (UIColor *)toolbarColor;
+ (UIColor *)blueColor;
+ (UIColor *)redColor;
+ (UIColor *)greenColor;
+ (UIColor *)linkColor;
+ (UIColor *)activeLinkColor;
+ (UIColor *)greyColor;

+ (UIEdgeInsets)buttonEdgeInsets;
- (OMNStyle *)styleForClass:(Class)class;
- (NSTimeInterval)animationDurationForKey:(NSString *)key;
- (void)reset;

@end
