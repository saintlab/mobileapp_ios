//
//  NSString+omn_json.m
//  omnom
//
//  Created by tea on 20.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "NSString+omn_json.h"

@implementation NSString (omn_json)

- (id)omn_jsonObjectNamedForClass:(Class)class {
  
  NSString *path = [[NSBundle bundleForClass:class] pathForResource:self ofType:nil];
  NSData *data = [NSData dataWithContentsOfFile:path];
  id object = [NSJSONSerialization JSONObjectWithData:data options:0UL error:nil];
  return object;
  
}

@end
