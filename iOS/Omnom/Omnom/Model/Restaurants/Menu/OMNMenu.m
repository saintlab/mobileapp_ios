//
//  GMenu.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenu.h"

@implementation OMNMenu

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
    
    NSArray *menuItems = data[@"menu"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:menuItems.count];
    
    for (id menuItemObject in menuItems) {
      OMNMenuItem *menuItem = [[OMNMenuItem alloc] initWithJsonData:menuItemObject];
      [items addObject:menuItem];
    }
    
    self.items = [items copy];
    
  }
  return self;
}

@end
