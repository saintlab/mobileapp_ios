//
//  OMNNotifierManager.m
//  omnom
//
//  Created by tea on 18.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNotifierManager.h"
#import "OMNConstants.h"
#import "OMNAnalitics.h"
#import "OMNUtils.h"
#import "AFHTTPResponseSerializer+omn_headers.h"

@interface NSData (omn_deviceToken)

- (NSString *)omn_deviceTokenString;

@end

@implementation OMNNotifierManager

+ (instancetype)sharedManager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:[OMNConstants notifierUrlString]]];
  });
  return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer omn_addCustomHeaders];
    self.requestSerializer.timeoutInterval = 10.0;
    
  }
  return self;
}

- (void)setUserID:(NSString *)userID {
  
  _userID = userID;
  [self registerUserDeviceIfPossible];
  
}

- (void)setDeviceToken:(NSData *)deviceToken {
  
  _deviceToken = deviceToken;
  [self registerUserDeviceIfPossible];
  
}

- (void)registerUserDeviceIfPossible {
  
  if (nil == _userID ||
      nil == _deviceToken) {
    return;
  }
  
  NSDictionary *parameters =
  @{
    @"user_id" : _userID,
    @"device_id" : [_deviceToken omn_deviceTokenString],
    @"device_type" : @(1),
    };
  
  NSLog(@"register device> %@", parameters);
  
  [self POST:@"/push/register_device" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

    if (![responseObject omn_isSuccessResponse]) {
    
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_REGISTER_DEVICE" jsonRequest:parameters jsonResponse:responseObject];
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_REGISTER_DEVICE" jsonRequest:parameters responseOperation:operation];
    
  }];
  
}

@end

@implementation NSData (omn_deviceToken)

- (NSString *)omn_deviceTokenString {
  
  const unsigned char *buffer = (const unsigned char *)[self bytes];
  if (!buffer) {
    return @"";
  }
  NSMutableString *hex = [NSMutableString stringWithCapacity:(self.length * 2)];
  for (NSUInteger i = 0; i < self.length; i++) {
    [hex appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)buffer[i]]];
  }
  
  return [NSString stringWithString:hex];
  
}

@end

