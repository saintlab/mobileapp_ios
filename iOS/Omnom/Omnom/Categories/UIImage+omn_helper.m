//
//  UIImage+omn_helper.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UIImage+omn_helper.h"

#define IS_IPHONE5 (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height==568)

@implementation UIImage (omn_helper)

+ (UIImage *)omn_imageNamed:(NSString *)name {

  if (IS_IPHONE5) {
    return [UIImage imageNamed:[name stringByAppendingString:@"-568h"]];
  }
  else {
    return [UIImage imageNamed:name];
  }
  
}

@end
