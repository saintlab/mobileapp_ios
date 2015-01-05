//
//  AFHTTPResponseSerializer+omn_headers.m
//  omnom
//
//  Created by tea on 30.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "AFHTTPResponseSerializer+omn_headers.h"
#import "OMNConstants.h"
#import <UIDevice-Hardware.h>

@implementation AFHTTPRequestSerializer (omn_headers)

- (void)omn_addCustomHeaders {
  
  [self setValue:CURRENT_BUILD forHTTPHeaderField:@"current-app-build"];
  [self setValue:CURRENT_VERSION forHTTPHeaderField:@"current-app-version"];
  [self setValue:CURRENT_BUILD forHTTPHeaderField:@"x-current-app-build"];
  [self setValue:CURRENT_VERSION forHTTPHeaderField:@"x-current-app-version"];
  [self setValue:@"Apple" forHTTPHeaderField:@"x-mobile-vendor"];
  [self setValue:@"iOs" forHTTPHeaderField:@"x-mobile-platform"];
  [self setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"x-mobile-os-version"];
  [self setValue:[[UIDevice currentDevice] modelName] forHTTPHeaderField:@"x-mobile-model"];
  
}

@end
