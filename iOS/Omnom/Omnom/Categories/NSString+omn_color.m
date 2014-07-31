//
//  NSString+omn_color.m
//  omnom
//
//  Created by tea on 31.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "NSString+omn_color.h"

@implementation NSString (omn_color)

- (UIColor *)omn_colorFormHex {
  
	/*Picky. Crashes by design.*/
	
	if (0 == self.length) {
    return [UIColor blackColor];
  }
  
	NSMutableString *s = [self mutableCopy];
	[s replaceOccurrencesOfString:@"#" withString:@"" options:0 range:NSMakeRange(0, [self length])];
	CFStringTrimWhitespace((__bridge CFMutableStringRef)s);
  
	NSString *redString = [s substringToIndex:2];
	NSString *greenString = [s substringWithRange:NSMakeRange(2, 2)];
	NSString *blueString = [s substringWithRange:NSMakeRange(4, 2)];
  
	unsigned int red = 0;
  unsigned int green = 0;
  unsigned int blue = 0;
  unsigned int alpha = 255;
  
	[[NSScanner scannerWithString:redString] scanHexInt:&red];
	[[NSScanner scannerWithString:greenString] scanHexInt:&green];
	[[NSScanner scannerWithString:blueString] scanHexInt:&blue];
  
  if (s.length == 8) {
    NSString *alphaString = [s substringWithRange:NSMakeRange(6, 2)];
    [[NSScanner scannerWithString:alphaString] scanHexInt:&alpha];
  }
  
	return [UIColor colorWithRed:(CGFloat)red/255.0f green:(CGFloat)green/255.0f blue:(CGFloat)blue/255.0f alpha:(CGFloat)alpha/255.0f];
}

@end
