//
//  GMenu.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GMenu.h"

@implementation GMenu

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    
    NSArray *menuItems = data[@"items"];
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:menuItems.count];
    
    for (id menuItemObject in menuItems) {
      GMenuItem *menuItem = [[GMenuItem alloc] initWithData:menuItemObject];
      [items addObject:menuItem];
    }
    
    self.items = [items copy];
    
  }
  return self;
}

@end
