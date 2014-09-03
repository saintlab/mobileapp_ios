//
//  OMNAnalitics.m
//  restaurants
//
//  Created by tea on 23.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAnalitics.h"
#import <Mixpanel.h>
#import "OMNConstants.h"

@interface OMNUser (omn_analitics)

- (NSDictionary *)properties;

@end

@implementation OMNAnalitics {
  Mixpanel *_mixpanel;
}

+ (instancetype)analitics {
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
    _mixpanel = [Mixpanel sharedInstanceWithToken:[OMNConstants mixpanelToken]];
  }
  return self;
}

- (void)logRegisterUser:(OMNUser *)user {
  
  [_mixpanel track:@"Register user" properties:user.properties];
  
}

- (void)logLoginUser:(OMNUser *)user {

  [_mixpanel track:@"Login user" properties:user.properties];
  
}

- (void)logCardAdd:(OMNUser *)user {
  
  [_mixpanel track:@"User add card" properties:user.properties];
  
}

- (void)logPayment:(OMNUser *)user {
  
  [_mixpanel track:@"User pay" properties:user.properties];
  
}

@end

@implementation OMNUser (omn_analitics)

- (NSDictionary *)properties {
  
  NSMutableDictionary *properties = [NSMutableDictionary dictionary];
  
  if (self.phone.length) {
    properties[@"phone"] = self.phone;
  }
  
  if (self.name.length) {
    properties[@"name"] = self.name;
  }
  
  if (self.email.length) {
    properties[@"email"] = self.email;
  }
  
  return properties;
  
}

@end
