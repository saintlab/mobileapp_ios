//
//  NSMutableArray+OMNIndexAdditions.m
//  beacon
//
//  Created by tea on 10.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "NSMutableArray+OMNIndexAdditions.h"

@implementation NSMutableArray (OMNIndexAdditions)

- (void)omn_removeFirstObject {
  
  if (self.count) {
    [self removeObjectAtIndex:0];
  }
  
}

@end
