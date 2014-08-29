//
//  OMNPushTexts.m
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPushTexts.h"

@implementation OMNPushTexts

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.at_entrance = [[OMNPushText alloc] initWithJsonData:jsonData[@"at_entrance"]];
    self.before_cheque = [[OMNPushText alloc] initWithJsonData:jsonData[@"before_cheque"]];
  }
  return self;
}

@end
