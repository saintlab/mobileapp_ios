//
//  OMNUser.m
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"

@implementation OMNUser

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    self.firstName = data[@"firstName"];
    self.lastName = data[@"lastName"];
    self.nickName = data[@"nickName"];
    self.email = data[@"email"];
    self.phone = data[@"phone"];
    self.password = data[@"password"];
    self.password_hash = data[@"password_hash"];
    self.status = data[@"status"];
    self.phone_validated = [data[@"phone_validated"] boolValue];
    self.email_validated = [data[@"email_validated"] boolValue];
  }
  return self;
}

@end
