//
//  NSString+jquery.m
//  acquiring
//
//  Created by tea on 18.02.14.
//
//

#import "NSString+jquery.h"

@implementation NSString (jquery)

+ (NSString *)loadScriptWithName:(NSString *)scriptFileName {
  
  NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:scriptFileName ofType:nil];
  return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}


+ (NSString *)jqueryScript {
  return [self loadScriptWithName:@"jquery-2.0.3.min"];
}

@end
