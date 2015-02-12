//
//  OMNMenuProductModifer.m
//  omnom
//
//  Created by tea on 02.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuModifer.h"

@implementation OMNMenuModifer

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    self.id = jsonData[@"id"];
    self.name = jsonData[@"name"];
    self.parent = jsonData[@"parent"];
    
  }
  return self;
}

@end
