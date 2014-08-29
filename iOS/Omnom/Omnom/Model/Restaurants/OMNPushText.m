//
//  OMNPushText.m
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPushText.h"

@implementation OMNPushText

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.category = jsonData[@"category"];
    self.greeting = jsonData[@"greeting"];
    self.open_action = jsonData[@"open_action"];
  }
  return self;
}

@end
