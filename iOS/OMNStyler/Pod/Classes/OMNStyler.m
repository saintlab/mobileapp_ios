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

- (NSNumber *)leftOffset {
  return @(15.0f);
}

- (NSNumber *)bottomToolbarHeight {
  return @(50.0f);
}

- (UIColor *)toolbarColor {
  
  return [UIColor colorWithWhite:0.95f alpha:0.95f];
  
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

- (NSTimeInterval)animationDurationForKey:(NSString *)key {
  
  NSTimeInterval animationDuration = 0.3;
  
  NSDictionary *timings = [_stylesCache objectForKey:@"timings"];
  if (nil == timings) {
    
#if kUseRemoteTimings
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.dropbox.com/s/jse4dnze4v4mqgs/timings.json?dl=1"]];
#else
    NSString *path = [[NSBundle mainBundle] pathForResource:@"timings" ofType:@"json"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:path], @"You need timings.json file to use styler");
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
#endif
    

    NSError *error = nil;
    timings = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    [_stylesCache setObject:timings forKey:@"timings"];
  }

  if (timings[key]) {
    animationDuration = [timings[key] doubleValue];
  }

  return animationDuration;
  
}

- (void)reset {
  [_stylesCache removeAllObjects];
}


@end
