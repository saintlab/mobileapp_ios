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
  
#ifdef APP_STORE
  [self setValue:@"appstore" forHTTPHeaderField:@"x-mobile-configuration"];
#elif defined (AD_HOC)
  [self setValue:@"ad-hoc" forHTTPHeaderField:@"x-mobile-configuration"];
#else
  [self setValue:@"debug" forHTTPHeaderField:@"x-mobile-configuration"];
#endif
  

  [self setValue:[OMNConstants installID] forHTTPHeaderField:@"x-mobile-device-id"];
  [self setValue:CURRENT_BUILD forHTTPHeaderField:@"current-app-build"];
  [self setValue:CURRENT_VERSION forHTTPHeaderField:@"current-app-version"];
  [self setValue:CURRENT_BUILD forHTTPHeaderField:@"x-current-app-build"];
  [self setValue:CURRENT_VERSION forHTTPHeaderField:@"x-current-app-version"];
  [self setValue:@"Apple" forHTTPHeaderField:@"x-mobile-vendor"];
  [self setValue:@"iOS" forHTTPHeaderField:@"x-mobile-platform"];
  [self setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"x-mobile-os-version"];
  [self setValue:[[UIDevice currentDevice] modelName] forHTTPHeaderField:@"x-mobile-model"];
  
  [self willChangeValueForKey:NSStringFromSelector(@selector(timeoutInterval))];
  self.timeoutInterval = 10.0;
  [self didChangeValueForKey:NSStringFromSelector(@selector(timeoutInterval))];
  
}

@end
