//
//  OMNQR.m
//  omnom
//
//  Created by tea on 30.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNQR.h"

@implementation OMNQR {
  NSDate *_date;
}

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.code = jsonData[@"code"];
    _date = [NSDate date];
  }
  return self;
}

- (BOOL)isValid {
  BOOL isValid = ([[NSDate date] timeIntervalSinceDate:_date] < 3.*60.*60.);
  return isValid;
}

@end
