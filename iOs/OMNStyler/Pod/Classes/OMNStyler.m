//
//  OMNStyler.m
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStyler.h"

@implementation OMNStyler {
  NSCache *_stylesCache;
}

+ (instancetype)styler {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _stylesCache = [[NSCache alloc] init];
  }
  return self;
}

- (OMNStyle *)styleForClass:(Class)class {
  
  NSString *className = NSStringFromClass(class);
  
  OMNStyle *style = [_stylesCache objectForKey:className];
  if (style) {
    return style;
  }
  
  NSString *path = [[NSBundle mainBundle] pathForResource:className ofType:@"json"];

  if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path]) {
    return nil;
  }
  
  NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
  
  style = [[OMNStyle alloc] initWithJsonData:jsonData];
  [_stylesCache setObject:style forKey:className];
  
  return style;
  
}

/*
 [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName : _manager.navBarButtonFont} forState:UIControlStateNormal];
 [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTitleTextAttributes:@{NSFontAttributeName : _manager.navBarButtonFont} forState:UIControlStateNormal];
 
 - (UIFont *)navBarTitleFont {
 return FuturaMediumFont(18.0f + kFuturaDeltaFontSize);
 }
 
 - (UIFont *)navBarButtonFont {
 return FuturaBookFont(18.0f + kFuturaDeltaFontSize);
 }
 
 - (UIFont *)navBarSelectorDefaultFont {
 return FuturaBookFont(16.0f + kFuturaDeltaFontSize);
 }
 
 - (UIFont *)navBarSelectorSelectedFont {
 return FuturaMediumFont(16.0f + kFuturaDeltaFontSize);
 }
 
 - (UIFont *)splitCellFont {
 return FuturaBookFont(16.0f + kFuturaDeltaFontSize);
 }
 
 - (UIFont *)splitTotalFont {
 return FuturaBookFont(21.0f + kFuturaDeltaFontSize);
 }
 */


@end
