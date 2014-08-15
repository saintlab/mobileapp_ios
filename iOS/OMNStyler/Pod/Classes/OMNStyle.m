//
//  OMNStyle.m
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStyle.h"

static BOOL stringIsEmpty(NSString *s);

@implementation OMNStyle {
  NSDictionary *_jsonObject;
  NSCache *_fontCache;
  NSCache *_colorCache;
}

- (instancetype)initWithJsonData:(NSData *)data {
  self = [super init];
  if (self) {
    NSError *error = nil;
    _jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    _fontCache = [[NSCache alloc] init];
    _colorCache = [[NSCache alloc] init];
    if (error) {
      NSLog(@"%@", error);
    }
    
  }
  return self;
}

- (id)objectForKey:(NSString *)key {
  
	id obj = [_jsonObject valueForKeyPath:key];
	return obj;
  
}

- (UIFont *)fontForKey:(NSString *)key {
  
	UIFont *cachedFont = [_fontCache objectForKey:key];
	if (cachedFont != nil)
		return cachedFont;
  
	NSString *fontObject = [self stringForKey:key];
  NSArray *fontComponents = [fontObject componentsSeparatedByString:@":"];
  
  UIFont *font = nil;
  
  if (2 == fontComponents.count) {
    
    font = [UIFont fontWithName:fontComponents[0] size:[fontComponents[1] floatValue]];
    
  }
  else {
    
    font = [UIFont systemFontOfSize:15.0f];
    
  }
  
	[_fontCache setObject:font forKey:key];
  
	return font;
}

- (CGFloat)floatForKey:(NSString *)key {
	
	id obj = [self objectForKey:key];
	if (obj == nil)
		return  0.0f;
	return [obj floatValue];
}

- (NSString *)stringForKey:(NSString *)key {
	
	id obj = [self objectForKey:key];
	if (obj == nil)
		return nil;
	if ([obj isKindOfClass:[NSString class]])
		return obj;
	if ([obj isKindOfClass:[NSNumber class]])
		return [obj stringValue];
	return nil;
}

- (UIColor *)colorForKey:(NSString *)key {
  
	UIColor *cachedColor = [_colorCache objectForKey:key];
	if (cachedColor) {
    return cachedColor;
  }
  
	NSString *colorString = [self stringForKey:key];
	UIColor *color = colorWithHexString(colorString);
	if (nil == color) {
    color = [UIColor blackColor];
  }
  
	[_colorCache setObject:color forKey:key];
  
	return color;
}

@end

static BOOL stringIsEmpty(NSString *s) {
	return s == nil || [s length] == 0;
}

UIColor *colorWithHexString(NSString *hexString) {
  
	/*Picky. Crashes by design.*/
	
	if (stringIsEmpty(hexString))
		return [UIColor blackColor];
  
	NSMutableString *s = [hexString mutableCopy];
	[s replaceOccurrencesOfString:@"#" withString:@"" options:0 range:NSMakeRange(0, [hexString length])];
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
