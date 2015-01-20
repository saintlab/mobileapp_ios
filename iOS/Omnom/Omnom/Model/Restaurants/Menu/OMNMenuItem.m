//
//  OMNMenuItem.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuItem.h"

@implementation OMNMenuItem

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
