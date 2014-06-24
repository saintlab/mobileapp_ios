//
//  GMenu.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenu.h"

@implementation OMNMenu

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    
    NSArray *menuItems = data[@"items"];
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:menuItems.count];
    
    for (id menuItemObject in menuItems) {
      OMNMenuItem *menuItem = [[OMNMenuItem alloc] initWithData:menuItemObject];
      [items addObject:menuItem];
    }
    
    self.items = [items copy];
    
  }
  return self;
}

@end
